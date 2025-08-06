import Foundation

// MARK: - Therapy Response Models
struct TherapyListResponse: Codable {
    let success: Bool
    let data: TherapyListData
}

struct TherapyListData: Codable {
    let therapies: [Therapy]
    let meta: TherapyMeta
}

struct Therapy: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let createdAt: String
    let phobia: TherapyPhobia
}

struct TherapyPhobia: Codable {
    let id: String
    let name: String
}

struct TherapyMeta: Codable {
    let total: Int
    let page: Int
    let limit: Int
    let lastPage: Int
}

// MARK: - Coping Strategy Models
struct CopingStrategyResponse: Codable {
    let success: Bool
    let data: CopingStrategyData
}

struct CopingStrategyData: Codable {
    let strategies: [CopingStrategy]
}

struct CopingStrategyDetailResponse: Codable {
    let success: Bool
    let data: CopingStrategy
}

// MARK: - Terapi Seansı Tamamlama Modelleri
struct CompleteStrategyRequest: Codable {
    let strategyId: String
}

struct CompleteStrategyResponse: Codable {
    let success: Bool
    let data: CompleteStrategyData
}

struct CompleteStrategyData: Codable {
    let completed: Bool
    let nextStrategyId: String?
}

// MARK: - Completed Strategies Response
struct CompletedStrategiesResponse: Codable {
    let success: Bool
    let data: CompletedStrategiesData
}

struct CompletedStrategiesData: Codable {
    let completedStrategyIds: [String]
}

// MARK: - Single Therapy Response
struct TherapyDetailResponse: Codable {
    let success: Bool
    let data: TherapyDetail
}

struct TherapyDetail: Codable {
    let id: String
    let name: String
    let description: String
    let durationInMinutes: Int
    let stepNumber: Int
    let isCompleted: Bool?
}

struct CopingStrategy: Codable {
    let id: String
    let title: String
    let content: String
    let stepNumber: Int
    let durationInMinutes: Int
    let isCompleted: Bool?
}

 
