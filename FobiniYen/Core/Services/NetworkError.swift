//
//  NetworkError.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternetConnection
    case unauthorized
    case forbidden
    case notFound
    case validationError(String)
    case serverError
    case decodingError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .noInternetConnection:
            return "İnternet bağlantısı yok"
        case .unauthorized:
            return "Yetkisiz erişim"
        case .forbidden:
            return "Yasaklı erişim"
        case .notFound:
            return "Kaynak bulunamadı"
        case .validationError(let message):
            return message
        case .serverError:
            return "Sunucu hatası"
        case .decodingError:
            return "Veri çözümleme hatası"
        case .unknown(let message):
            return "Bilinmeyen hata: \(message)"
        }
    }
}