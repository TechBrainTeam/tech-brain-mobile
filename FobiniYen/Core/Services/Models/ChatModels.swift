//
//  ChatModels.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Chat Request Models
struct SendMessageRequest: Codable {
    let userPhobiaId: String
    let message: String
}

// MARK: - Chat Response Models
struct SendMessageResponse: Codable {
    let success: Bool
    let data: ChatMessageData
}

struct ChatMessageData: Codable {
    let reply: String
}

struct ChatHistoryResponse: Codable {
    let success: Bool
    let data: [ChatMessage]
    let meta: ChatMeta
}

struct ChatMessage: Codable {
    let id: String
    let role: String // "model" or "user"
    let message: String
    let createdAt: String
}

struct ChatMeta: Codable {
    let totalItems: Int
    let currentPage: Int
    let totalPages: Int
    let pageSize: Int
}
