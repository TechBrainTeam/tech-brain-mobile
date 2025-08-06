import Foundation

// MARK: - User Phobia List Models
struct UserPhobiaListResponse: Codable {
    let success: Bool
    let data: UserPhobiaListData
}

struct UserPhobiaListData: Codable {
    let userPhobias: [UserPhobiaListItem]
    let meta: UserPhobiaMeta
}

struct UserPhobiaListItem: Codable, Identifiable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let phobia: Phobia
}

struct UserPhobiaMeta: Codable {
    let total: Int
    let page: Int
    let limit: Int
    let lastPage: Int
} 