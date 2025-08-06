//
//  APIEndpoint.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - API Endpoint
enum APIEndpoint {
    
    // MARK: - Auth Endpoints
    case register(RegisterRequest)
    case login(LoginRequest)
    
    // MARK: - Phobia Endpoints
    case getPhobias(search: String?, categoryId: String?, page: Int?, limit: Int?)
    case getPhobiaDetail(phobiaId: String)
    
    // MARK: - User Phobia Endpoints
    case createUserPhobia(CreateUserPhobiaRequest)
    case getUserPhobias(page: Int?, limit: Int?)
    
    // MARK: - Chat Endpoints
    case sendMessage(SendMessageRequest)
    case getChatHistory(userPhobiaId: String, page: Int?, limit: Int?)
    
    // MARK: - Therapy Endpoints
    case copingStrategies(therapyId: String)
    case getCopingStrategy(strategyId: String)
    case getTherapy(therapyId: String)
    case completeStrategy(CompleteStrategyRequest)
    case getTherapies(phobiaId: String?)
    case getCompletedStrategies(userPhobiaId: String)
    
    // MARK: - User Profile Endpoints
    case getUserProfile
    case updateUserProfile(firstName: String, lastName: String)
    
    // MARK: - Computed Properties
    var path: String {
        switch self {
        case .register:
            return "/api/auth/register"
        case .login:
            return "/api/auth/login"
        case .getPhobias:
            return "/api/phobia/list"
        case .getPhobiaDetail(let phobiaId):
            return "/api/phobia/\(phobiaId)"
        case .createUserPhobia:
            return "/api/user-phobia/create"
        case .getUserPhobias:
            return "/api/user-phobia/list"
        case .sendMessage:
            return "/api/chat/send"
        case .getChatHistory(let userPhobiaId, _, _):
            return "/api/chat/history/\(userPhobiaId)"
        case .copingStrategies(let therapyId):
            return "/api/coping-strategy/list?therapyId=\(therapyId)"
        case .getCopingStrategy(let strategyId):
            return "/api/coping-strategy/\(strategyId)"
        case .getTherapy(let therapyId):
            return "/api/therapy/\(therapyId)"
        case .completeStrategy:
            return "/api/coping-strategy/complete"
        case .getTherapies:
            return "/api/therapy/list"
        case .getCompletedStrategies(let userPhobiaId):
            return "/api/coping-strategy/completed/\(userPhobiaId)"
        case .getUserProfile:
            return "/api/user/profile"
        case .updateUserProfile:
            return "/api/user/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .login, .createUserPhobia, .sendMessage, .updateUserProfile, .completeStrategy:
            return .POST
        case .getPhobias, .getPhobiaDetail, .getChatHistory, .copingStrategies, .getCopingStrategy, .getTherapy, .getTherapies, .getCompletedStrategies, .getUserPhobias, .getUserProfile:
            return .GET
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .register(let request):
            return try? request.asDictionary()
        case .login(let request):
            return try? request.asDictionary()
        case .createUserPhobia(let request):
            return try? request.asDictionary()
        case .sendMessage(let request):
            return try? request.asDictionary()
        case .completeStrategy(let request):
            return try? request.asDictionary()
        case .getPhobias(let search, let categoryId, let page, let limit):
            var params: [String: Any] = [:]
            if let search = search { params["search"] = search }
            if let categoryId = categoryId { params["categoryId"] = categoryId }
            if let page = page { params["page"] = page }
            if let limit = limit { params["limit"] = limit }
            return params.isEmpty ? nil : params
        case .getChatHistory(_, let page, let limit):
            var params: [String: Any] = [:]
            if let page = page { params["page"] = page }
            if let limit = limit { params["limit"] = limit }
            return params.isEmpty ? nil : params
        case .getTherapies(let phobiaId):
            var params: [String: Any] = [:]
            if let phobiaId = phobiaId { params["phobiaId"] = phobiaId }
            return params.isEmpty ? nil : params
        case .getUserPhobias(let page, let limit):
            var params: [String: Any] = [:]
            if let page = page { params["page"] = page }
            if let limit = limit { params["limit"] = limit }
            return params.isEmpty ? nil : params
        case .updateUserProfile(let firstName, let lastName):
            return ["firstName": firstName, "lastName": lastName]
        case .getPhobiaDetail, .copingStrategies, .getCopingStrategy, .getTherapy, .getCompletedStrategies, .getUserProfile:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .register, .login:
            return false
        case .getPhobias, .getPhobiaDetail, .createUserPhobia, .sendMessage, .getChatHistory, .copingStrategies, .getCopingStrategy, .getTherapy, .completeStrategy, .getTherapies, .getCompletedStrategies, .getUserPhobias, .getUserProfile, .updateUserProfile:
            return true
        }
    }
}

// MARK: - Encodable Extension
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "EncodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to convert to dictionary"])
        }
        return dictionary
    }
}
