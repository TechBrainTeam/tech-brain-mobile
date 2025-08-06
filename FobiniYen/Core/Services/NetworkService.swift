//
//  NetworkService.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation
import Alamofire

// MARK: - Network Protocols
protocol NetworkServiceProtocol {
    func request<T: Codable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T
    func requestWithoutResponse(_ endpoint: APIEndpoint) async throws
}

// MARK: - Network Service
final class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let session: Session
    private let tokenManager: TokenManager
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        self.session = Session(configuration: configuration)
        self.tokenManager = TokenManager.shared
    }
    
    // MARK: - Public Methods
    func request<T: Codable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        let request = try await buildRequest(for: endpoint)
        
        print("🌐 Network Request:")
        print("   URL: \(request.url?.absoluteString ?? "nil")")
        print("   Method: \(request.httpMethod ?? "nil")")
        print("   Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("   Body: \(bodyString)")
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(request)
                .validate()
                .responseDecodable(of: T.self) { response in
                    
                    print("📱 Network Response:")
                    print("   Status Code: \(response.response?.statusCode ?? 0)")
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("   Response: \(responseString)")
                    }
                    if let error = response.error {
                        print("   Error: \(error)")
                    }
                    
                    switch response.result {
                    case .success(let data):
                        print("✅ Network Success!")
                        continuation.resume(returning: data)
                    case .failure(let error):
                        print("❌ Network Failure: \(error)")
                        let networkError = self.handleError(error, response: response.response, data: response.data)
                        continuation.resume(throwing: networkError)
                    }
                }
        }
    }
    
    func requestWithoutResponse(_ endpoint: APIEndpoint) async throws {
        let request = try await buildRequest(for: endpoint)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(request)
                .validate()
                .response { response in
                    if let error = response.error {
                        let networkError = self.handleError(error, response: response.response, data: response.data)
                        continuation.resume(throwing: networkError)
                    } else {
                        continuation.resume()
                    }
                }
        }
    }
    
    // MARK: - Private Methods
    private func buildRequest(for endpoint: APIEndpoint) async throws -> URLRequest {
        let url = "\(Constants.URLPaths.BASE_URL)\(endpoint.path)"
        
        guard let urlComponents = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }
        
        guard let finalURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authentication header ekle
        if endpoint.requiresAuth {
            if let token = tokenManager.getAccessToken() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                throw NetworkError.unauthorized
            }
        }
        
        // Parameters
        if let parameters = endpoint.parameters {
            switch endpoint.method {
            case .GET:
                // Query parameters için URL'e ekle
                var components = URLComponents(url: finalURL, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                if let newURL = components?.url {
                    request.url = newURL
                }
            case .POST, .PUT, .DELETE:
                // Body parameters için JSON encode et
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
        }
        
        return request
    }
    
    private func handleError(_ error: AFError, response: HTTPURLResponse?, data: Data?) -> NetworkError {
        // HTTP status code kontrol et
        if let statusCode = response?.statusCode {
            print("📊 HTTP Status Code: \(statusCode)")
            switch statusCode {
            case 400:
                return .validationError(parseErrorMessage(from: data))
            case 401:
                tokenManager.clearTokens()
                return .unauthorized
            case 403:
                return .forbidden
            case 404:
                return .notFound
            case 422:
                return .validationError(parseErrorMessage(from: data))
            case 500...599:
                return .serverError
            default:
                break
            }
        }
        
        // Network bağlantı hatalarını kontrol et
        if error.isSessionTaskError {
            return .noInternetConnection
        }
        
        if error.isResponseSerializationError {
            return .decodingError
        }
        
        return .unknown(error.localizedDescription)
    }
    
    private func parseErrorMessage(from data: Data?) -> String {
        guard let data = data else {
            return "Bilinmeyen hata oluştu"
        }
        
        print("🔍 Parsing error from response data: \(String(data: data, encoding: .utf8) ?? "nil")")
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            // API'den gelen message alanını kontrol et
            if let message = json?["message"] as? String {
                return message
            }
            
            // Başka format dene
            if let error = json?["error"] as? String {
                return error
            }
            
            // success field varsa kontrol et
            if let success = json?["success"] as? Bool, !success {
                if let message = json?["message"] as? String {
                    return message
                }
            }
            
        } catch {
            print("❌ JSON parse error: \(error)")
        }
        
        return "Bilinmeyen hata oluştu"
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
