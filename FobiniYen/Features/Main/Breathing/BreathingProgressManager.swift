import Foundation

class BreathingProgressManager {
    static let shared = BreathingProgressManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Session Recording
    func recordSession(duration: TimeInterval, exerciseType: String = "general") {
        let today = getTodayString()
        let todaySessions = defaults.integer(forKey: "breathing_sessions_\(today)")
        let todayMinutes = defaults.double(forKey: "breathing_minutes_\(today)")
        
        // Bugünkü seans sayısını artır
        defaults.set(todaySessions + 1, forKey: "breathing_sessions_\(today)")
        
        // Bugünkü dakika sayısını artır
        defaults.set(todayMinutes + duration/60, forKey: "breathing_minutes_\(today)")
        
        // Son seans tarihini kaydet
        defaults.set(Date(), forKey: "last_breathing_session")
        
        // Toplam istatistikleri güncelle
        updateTotalStats(duration: duration)
        
        print("📊 Breathing session recorded: \(duration/60) minutes")
    }
    
    // MARK: - Statistics Retrieval
    func getTodayStats() -> (sessions: Int, minutes: Double) {
        let today = getTodayString()
        let sessions = defaults.integer(forKey: "breathing_sessions_\(today)")
        let minutes = defaults.double(forKey: "breathing_minutes_\(today)")
        return (sessions, minutes)
    }
    
    func getDailyStreak() -> Int {
        var streak = 0
        let calendar = Calendar.current
        
        // Son 30 günü kontrol et (maksimum streak için)
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let dateString = getDateString(from: date)
            let sessions = defaults.integer(forKey: "breathing_sessions_\(dateString)")
            
            if sessions > 0 {
                streak += 1
            } else {
                break // Streak kırıldı
            }
        }
        
        return streak
    }
    
    func getCurrentStreak() -> Int {
        return getDailyStreak()
    }
    
    // MARK: - Daily Check Methods
    func hasCompletedDailyCheckToday() -> Bool {
        let today = getTodayString()
        return defaults.bool(forKey: "daily_check_completed_\(today)")
    }
    
    func completeDailyCheck() {
        let today = getTodayString()
        defaults.set(true, forKey: "daily_check_completed_\(today)")
        
        // 1 dakikalık dummy nefes seansı kaydet
        recordSession(duration: 60.0)
        
        print("✅ Daily check completed for \(today)")
    }
    
    func getTotalStats() -> (totalSessions: Int, totalMinutes: Double) {
        let totalSessions = defaults.integer(forKey: "total_breathing_sessions")
        let totalMinutes = defaults.double(forKey: "total_breathing_minutes")
        return (totalSessions, totalMinutes)
    }
    
    func getLastSessionDate() -> Date? {
        return defaults.object(forKey: "last_breathing_session") as? Date
    }
    
    // MARK: - Helper Methods
    private func getTodayString() -> String {
        return getDateString(from: Date())
    }
    
    private func getDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func updateTotalStats(duration: TimeInterval) {
        let currentTotalSessions = defaults.integer(forKey: "total_breathing_sessions")
        let currentTotalMinutes = defaults.double(forKey: "total_breathing_minutes")
        
        defaults.set(currentTotalSessions + 1, forKey: "total_breathing_sessions")
        defaults.set(currentTotalMinutes + duration/60, forKey: "total_breathing_minutes")
    }
    
    // MARK: - Reset Methods (Debug için)
    func resetAllStats() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        print("🗑️ All breathing stats reset")
    }
    
    func resetTodayStats() {
        let today = getTodayString()
        defaults.removeObject(forKey: "breathing_sessions_\(today)")
        defaults.removeObject(forKey: "breathing_minutes_\(today)")
        print("🗑️ Today's breathing stats reset")
    }
} 