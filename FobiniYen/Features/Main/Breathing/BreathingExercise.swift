import SwiftUI

struct BreathingExercise: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let description: String
    let rhythm: String
    let cycles: String
    let icon: String
    let iconColor: Color
    let benefits: [String]
    
    static func == (lhs: BreathingExercise, rhs: BreathingExercise) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct BreathingStatistics {
    let todaySessions: Int
    let totalMinutes: Double
    let dailyStreak: Int
} 