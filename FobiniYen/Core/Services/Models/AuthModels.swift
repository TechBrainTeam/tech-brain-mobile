//
//  AuthModels.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Auth Request Models
struct RegisterRequest: Codable {
    let email: String
    let password: String
    let confirmPassword: String
    let username: String
    let firstName: String
    let lastName: String
    let profileImage: String?
}

struct LoginRequest: Codable {
    let emailOrUsername: String
    let password: String
}

// MARK: - Auth Response Models
struct RegisterResponse: Codable {
    let success: Bool
    let message: String?
    let data: RegisterData?
}

struct RegisterData: Codable {
    let token: String
    let user: User
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String?
    let data: LoginData
}

struct LoginData: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let profileImage: String?
    let createdAt: String?
    let updatedAt: String?
}
