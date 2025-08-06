import Foundation
import SwiftUI

class BreathingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var statistics = BreathingStatistics(
        todaySessions: 0,
        totalMinutes: 0.0,
        dailyStreak: 0
    )
    
    @Published var exercises: [BreathingExercise] = [
        BreathingExercise(
            id: "4-7-8",
            name: "4-7-8 Nefes Tekniği",
            description: "Anksiyeteyi azaltan ve uykuyu destekleyen sakinleştirici teknik",
            rhythm: "4-7-8 ritmi",
            cycles: "4 döngü",
            icon: "wind",
            iconColor: Color.blue,
            benefits: ["Anksiyeteyi azaltır", "Gevşeme sağlar"]
        ),
        BreathingExercise(
            id: "box",
            name: "Kutu Nefes Tekniği",
            description: "Nefes alma, tutma, verme ve tutma için eşit süre - Navy SEALs tarafından kullanılır",
            rhythm: "4-4-4 ritmi",
            cycles: "8 döngü",
            icon: "heart.fill",
            iconColor: .green,
            benefits: ["Odaklanmayı artırır", "Stresi azaltır"]
        ),
        BreathingExercise(
            id: "quick",
            name: "Hızlı Sakinlik",
            description: "Anlık anksiyete rahatlaması için hızlı etkili nefes tekniği",
            rhythm: "3-2-5 ritmi",
            cycles: "6 döngü",
            icon: "bolt.fill",
            iconColor: .purple,
            benefits: ["Hızlı rahatlama", "Paniği azaltır"]
        )
    ]
    
    // MARK: - Methods
    func loadStatistics() {
        let progressManager = BreathingProgressManager.shared
        let todayStats = progressManager.getTodayStats()
        let dailyStreak = progressManager.getDailyStreak()
        
        statistics = BreathingStatistics(
            todaySessions: todayStats.sessions,
            totalMinutes: todayStats.minutes,
            dailyStreak: dailyStreak
        )
    }
    
    func startExercise(_ exercise: BreathingExercise) {
        // TODO: Navigate to exercise detail
        print("Starting exercise: \(exercise.name)")
    }
} 
