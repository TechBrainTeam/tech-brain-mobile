//
//  AuthService.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    func register(email: String, password: String, confirmPassword: String, username: String, firstName: String, lastName: String, profileImage: String?) async throws -> RegisterResponse
    func login(emailOrUsername: String, password: String) async throws -> LoginResponse
    func logout()
    func isLoggedIn() -> Bool
    func getCurrentUser() -> User?
}

// MARK: - Auth Service
final class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    private let networkService: NetworkServiceProtocol
    private let tokenManager: TokenManager
    private var currentUser: User?
    
    private init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        self.tokenManager = TokenManager.shared
        initializeUser()
    }
    
    private func initializeUser() {
        // Uygulama başladığında kullanıcı bilgilerini Keychain'den yükle
        currentUser = tokenManager.getCurrentUser()
    }
    
    // MARK: - Public Methods
    func register(email: String, password: String, confirmPassword: String, username: String, firstName: String, lastName: String, profileImage: String?) async throws -> RegisterResponse {
        let request = RegisterRequest(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            username: username,
            firstName: firstName,
            lastName: lastName,
            profileImage: profileImage
        )
        
        print("📡 AuthService register request:")
        print("   - email: '\(email)'")
        print("   - password: '\(password)'")
        print("   - confirmPassword: '\(confirmPassword)'")
        print("   - username: '\(username)'")
        print("   - firstName: '\(firstName)'")
        print("   - lastName: '\(lastName)'")
        print("   - profileImage: '\(profileImage ?? "nil")'")
        
        let endpoint = APIEndpoint.register(request)
        
        let response: RegisterResponse = try await networkService.request(endpoint, responseType: RegisterResponse.self)
        
        // Başarılı kayıt sonrası token ve kullanıcı bilgilerini kaydet
        if response.success, let data = response.data {
            tokenManager.saveTokens(accessToken: data.token)
            currentUser = data.user
            tokenManager.saveUser(data.user)
            print("✅ Register successful - Token and user data saved")
        }
        
        return response
    }
    
    func login(emailOrUsername: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(emailOrUsername: emailOrUsername, password: password)
        let endpoint = APIEndpoint.login(request)
        
        let response: LoginResponse = try await networkService.request(endpoint, responseType: LoginResponse.self)
        
        // Token'ı kaydet
        tokenManager.saveTokens(accessToken: response.data.token)
        
        // Kullanıcı bilgilerini kaydet
        currentUser = response.data.user
        tokenManager.saveUser(response.data.user)
        
        return response
    }
    
    func logout() {
        tokenManager.clearTokens()
        currentUser = nil
    }
    
    func isLoggedIn() -> Bool {
        return tokenManager.isLoggedIn()
    }
    
    func getCurrentUser() -> User? {
        // Önce memory'deki currentUser'ı kontrol et
        if let currentUser = currentUser {
            return currentUser
        }
        
        // Memory'de yoksa Keychain'den al
        let savedUser = tokenManager.getCurrentUser()
        currentUser = savedUser
        return savedUser
    }
}

// MARK: - Phobia Service
final class PhobiaService {
    
    static let shared = PhobiaService()
    
    private let networkService: NetworkServiceProtocol
    
    private init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func getPhobias(search: String? = nil, categoryId: String? = nil, page: Int? = nil, limit: Int? = nil) async throws -> PhobiaListResponse {
        let endpoint = APIEndpoint.getPhobias(search: search, categoryId: categoryId, page: page, limit: limit)
        return try await networkService.request(endpoint, responseType: PhobiaListResponse.self)
    }
    
    func getPhobiaDetail(phobiaId: String) async throws -> PhobiaDetailResponse {
        let endpoint = APIEndpoint.getPhobiaDetail(phobiaId: phobiaId)
        return try await networkService.request(endpoint, responseType: PhobiaDetailResponse.self)
    }
    
    func createUserPhobia(phobiaId: String) async throws -> CreateUserPhobiaResponse {
        let request = CreateUserPhobiaRequest(phobiaId: phobiaId)
        let endpoint = APIEndpoint.createUserPhobia(request)
        return try await networkService.request(endpoint, responseType: CreateUserPhobiaResponse.self)
    }
    
    func getCopingStrategies(therapyId: String) async throws -> CopingStrategyResponse {
        let endpoint = APIEndpoint.copingStrategies(therapyId: therapyId)
        return try await networkService.request(endpoint, responseType: CopingStrategyResponse.self)
    }
}

// MARK: - Chat Service
final class ChatService {
    
    static let shared = ChatService()
    
    private let networkService: NetworkServiceProtocol
    
    private init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func sendMessage(userPhobiaId: String, message: String) async throws -> SendMessageResponse {
        let request = SendMessageRequest(userPhobiaId: userPhobiaId, message: message)
        let endpoint = APIEndpoint.sendMessage(request)
        return try await networkService.request(endpoint, responseType: SendMessageResponse.self)
    }
    
    func getChatHistory(userPhobiaId: String, page: Int? = nil, limit: Int? = nil) async throws -> ChatHistoryResponse {
        let endpoint = APIEndpoint.getChatHistory(userPhobiaId: userPhobiaId, page: page, limit: limit)
        return try await networkService.request(endpoint, responseType: ChatHistoryResponse.self)
    }
}
