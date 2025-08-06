import Foundation

class TherapyService {
    static let shared = TherapyService()
    
    private let networkService: NetworkServiceProtocol
    
    private init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func getTherapies(phobiaId: String? = nil) async throws -> [Therapy] {
        let endpoint = APIEndpoint.getTherapies(phobiaId: phobiaId)
        let response: TherapyListResponse = try await networkService.request(endpoint, responseType: TherapyListResponse.self)
        return response.data.therapies
    }
    
    func createUserPhobia(phobiaId: String) async throws -> UserPhobia {
        let request = CreateUserPhobiaRequest(phobiaId: phobiaId)
        let endpoint = APIEndpoint.createUserPhobia(request)
        let response: CreateUserPhobiaResponse = try await networkService.request(endpoint, responseType: CreateUserPhobiaResponse.self)
        return response.data
    }
    
    func getUserPhobias(page: Int? = nil, limit: Int? = nil) async throws -> [UserPhobiaListItem] {
        let endpoint = APIEndpoint.getUserPhobias(page: page, limit: limit)
        let response: UserPhobiaListResponse = try await networkService.request(endpoint, responseType: UserPhobiaListResponse.self)
        return response.data.userPhobias
    }
    
    func getCopingStrategies(therapyId: String) async throws -> [CopingStrategy] {
        let endpoint = APIEndpoint.copingStrategies(therapyId: therapyId)
        let response: CopingStrategyResponse = try await networkService.request(endpoint, responseType: CopingStrategyResponse.self)
        return response.data.strategies
    }
    
    func getCopingStrategy(strategyId: String) async throws -> CopingStrategy {
        let endpoint = APIEndpoint.getCopingStrategy(strategyId: strategyId)
        let response: CopingStrategyDetailResponse = try await networkService.request(endpoint, responseType: CopingStrategyDetailResponse.self)
        return response.data
    }
    
    func getTherapy(therapyId: String) async throws -> TherapyDetail {
        let endpoint = APIEndpoint.getTherapy(therapyId: therapyId)
        let response: TherapyDetailResponse = try await networkService.request(endpoint, responseType: TherapyDetailResponse.self)
        return response.data
    }
    
    func completeStrategy(strategyId: String) async throws -> CompleteStrategyData {
        let request = CompleteStrategyRequest(strategyId: strategyId)
        let endpoint = APIEndpoint.completeStrategy(request)
        let response: CompleteStrategyResponse = try await networkService.request(endpoint, responseType: CompleteStrategyResponse.self)
        return response.data
    }
    
    func getCompletedStrategies(userPhobiaId: String) async throws -> [String] {
        let endpoint = APIEndpoint.getCompletedStrategies(userPhobiaId: userPhobiaId)
        let response: CompletedStrategiesResponse = try await networkService.request(endpoint, responseType: CompletedStrategiesResponse.self)
        return response.data.completedStrategyIds
    }
} 
