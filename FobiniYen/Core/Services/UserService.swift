import Foundation

struct UserProfile: Codable {
    let id: String
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let profileImage: String?
    let createdAt: String
    let updatedAt: String
}

struct UserProfileResponse: Codable {
    let success: Bool
    let data: UserProfile
}

class UserService {
    static let shared = UserService()
    private init() {}
    
    func getUserProfile() async throws -> UserProfile {
        let endpoint = APIEndpoint.getUserProfile
        let response: UserProfileResponse = try await NetworkService.shared.request(endpoint, responseType: UserProfileResponse.self)
        return response.data
    }
    
    func updateUserProfile(firstName: String, lastName: String) async throws -> UserProfile {
        let endpoint = APIEndpoint.updateUserProfile(firstName: firstName, lastName: lastName)
        let response: UserProfileResponse = try await NetworkService.shared.request(endpoint, responseType: UserProfileResponse.self)
        return response.data
    }
} 