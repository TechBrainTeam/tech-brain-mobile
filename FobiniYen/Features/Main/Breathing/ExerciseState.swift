import Foundation
import SwiftUI

class ExerciseState: ObservableObject {
    @Published var currentExercise: BreathingExercise? = nil
    
    func setExercise(_ exercise: BreathingExercise) {
        currentExercise = exercise
    }
    
    func clearExercise() {
        currentExercise = nil
    }
} 