//
//  PhobiaModels.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Phobia List Models
struct PhobiaListResponse: Codable {
    let success: Bool
    let data: PhobiaListData
}

struct PhobiaListData: Codable {
    let categories: [PhobiaCategory]
    let data: [Phobia]
    let meta: PaginationMeta
}

struct PaginationMeta: Codable {
    let total: Int
    let page: Int
    let limit: Int
    let lastPage: Int
}

struct PhobiaCategory: Codable {
    let id: String
    let name: String
}

struct Phobia: Codable {
    let id: String
    let name: String
    let englishName: String
    let description: String
    let percentage: Double
    let categories: [PhobiaCategory]
    let imageUrl: String?
    let createdAt: String
    let updatedAt: String
}

// MARK: - Phobia Detail Models
struct PhobiaDetailResponse: Codable {
    let success: Bool
    let data: PhobiaDetail
}

struct PhobiaDetail: Codable {
    let id: String
    let name: String
    let englishName: String
    let description: String
    let percentage: Double
    let imageUrl: String?
    let commonSymptoms: [String]
    let therapies: [PhobiaTherapy]
}

struct PhobiaTherapy: Codable {
    let id: String
    let name: String
    let strategies: [PhobiaStrategy]
}

struct PhobiaStrategy: Codable {
    let id: String
    let title: String
}

// MARK: - User Phobia Models
struct CreateUserPhobiaRequest: Codable {
    let phobiaId: String
}

struct CreateUserPhobiaResponse: Codable {
    let success: Bool
    let data: UserPhobia
}

struct UserPhobia: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
}


