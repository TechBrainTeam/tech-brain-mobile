import Foundation
import SwiftUI

class BreathingExerciseDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var currentCycle = 1
    @Published var totalCycles = 4
    @Published var elapsedTime: TimeInterval = 0
    @Published var breathingInstruction = "Nefes Al"
    @Published var circleScale: CGFloat = 1.0
    @Published var circleSize: CGFloat = 200
    
    // MARK: - Callback
    var onExerciseCompleted: (() -> Void)?
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var breathingTimer: Timer?
    private var breathingPhase: BreathingPhase = .inhale
    
    // MARK: - Published Properties for Animation
    @Published var breathingDuration: TimeInterval = 4.0
    
    // MARK: - Computed Properties
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - Breathing Phases
    enum BreathingPhase {
        case inhale, hold, exhale, holdExhale
        
        var instruction: String {
            switch self {
            case .inhale: return "Nefes Al"
            case .hold: return "Tut"
            case .exhale: return "Nefes Ver"
            case .holdExhale: return "Tut"
            }
        }
        
        var duration: TimeInterval {
            switch self {
            case .inhale: return 4.0
            case .hold: return 7.0
            case .exhale: return 8.0
            case .holdExhale: return 0.0 // 4-7-8 tekniğinde yok
            }
        }
        
        var scale: CGFloat {
            switch self {
            case .inhale: return 1.3
            case .hold: return 1.3
            case .exhale: return 1.0
            case .holdExhale: return 1.0
            }
        }
    }
    
    // MARK: - Methods
    func toggleExercise() {
        if isActive {
            pauseExercise()
        } else {
            startExercise()
        }
    }
    
    func startExercise() {
        isActive = true
        startTimer()
        startBreathingCycle()
    }
    
    func pauseExercise() {
        isActive = false
        stopTimer()
        stopBreathingCycle()
    }
    
    func resetExercise() {
        pauseExercise()
        currentCycle = 1
        elapsedTime = 0
        breathingPhase = .inhale
        breathingInstruction = "Nefes Al"
        circleScale = 1.0
    }
    
    func completeExercise() {
        // Egzersiz tamamlandığında istatistikleri kaydet
        if elapsedTime > 0 {
            BreathingProgressManager.shared.recordSession(duration: elapsedTime)
            print("✅ Exercise completed: \(elapsedTime/60) minutes recorded")
            
            // Callback'i çağır
            onExerciseCompleted?()
        }
    }
    
    // MARK: - Private Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
            
            // Timer'da da döngü kontrolü yap
            let totalCycleTime: TimeInterval = 19.0
            let completedCycles = Int(self.elapsedTime / totalCycleTime) + 1
            
            if completedCycles > self.totalCycles {
                print("⏰ Timer: All cycles completed! Stopping exercise...")
                DispatchQueue.main.async {
                    self.pauseExercise()
                    self.completeExercise()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startBreathingCycle() {
        breathingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateBreathingPhase()
        }
    }
    
    private func stopBreathingCycle() {
        breathingTimer?.invalidate()
        breathingTimer = nil
    }
    
    private func updateBreathingPhase() {
        // 4-7-8 tekniği için basit implementasyon
        let totalCycleTime: TimeInterval = 19.0 // 4 + 7 + 8
        let cycleProgress = elapsedTime.truncatingRemainder(dividingBy: totalCycleTime)
        
        if cycleProgress < 4.0 {
            setBreathingPhase(.inhale)
        } else if cycleProgress < 11.0 {
            setBreathingPhase(.hold)
        } else {
            setBreathingPhase(.exhale)
        }
        
        // Döngü sayısını güncelle
        let completedCycles = Int(elapsedTime / totalCycleTime) + 1
        if completedCycles != currentCycle {
            currentCycle = min(completedCycles, totalCycles)
            
            print("🔄 Cycle updated: \(currentCycle)/\(totalCycles)")
            
            // Tüm döngüler tamamlandığında egzersizi durdur
            if currentCycle > totalCycles {
                print("✅ All cycles completed! Stopping exercise...")
                DispatchQueue.main.async {
                    self.pauseExercise()
                    self.completeExercise()
                }
            }
        }
    }
    
    private func setBreathingPhase(_ phase: BreathingPhase) {
        guard breathingPhase != phase else { return }
        
        breathingPhase = phase
        breathingInstruction = phase.instruction
        breathingDuration = phase.duration
        
        withAnimation(.easeInOut(duration: phase.duration)) {
            circleScale = phase.scale
        }
    }
} 
