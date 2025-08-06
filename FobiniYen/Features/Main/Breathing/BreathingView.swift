import SwiftUI

struct BreathingView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = BreathingViewModel()
    @StateObject private var exerciseState = ExerciseState()
    @State private var showingExerciseDetail = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Statistics Card
                    statisticsCard
                    
                    // Exercise Selection
                    exerciseSelectionSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingExerciseDetail, onDismiss: {
                print("📱 Sheet dismissed")
                exerciseState.clearExercise()
                viewModel.loadStatistics()
            }) {
                Group {
                    if let exercise = exerciseState.currentExercise {
                        BreathingExerciseDetailView(
                            exercise: exercise,
                            onExerciseCompleted: {
                                viewModel.loadStatistics()
                            }
                        )
                        .onAppear {
                            print("📱 Sheet showing exercise: \(exercise.name)")
                        }
                    } else {
                        Text("Egzersiz yükleniyor...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                            .onAppear {
                                print("❌ exerciseState.currentExercise is nil in sheet!")
                            }
                    }
                }
            }
            .onAppear {
                viewModel.loadStatistics()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nefes Egzersizleri")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Rehberli nefes egzersizleri ile zihninizi sakinleştirin ve anksiyeteyi azaltın")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Statistics Card
    private var statisticsCard: some View {
        HStack(spacing: 0) {
            StatisticItem(
                value: "\(viewModel.statistics.todaySessions)",
                title: "Bugün Seans",
                color: .primary
            )
            
            Divider()
                .frame(height: 40)
            
            StatisticItem(
                value: "\(Int(viewModel.statistics.totalMinutes))",
                title: "Toplam Dakika",
                color: .green
            )
            
            Divider()
                .frame(height: 40)
            
            StatisticItem(
                value: "\(viewModel.statistics.dailyStreak)",
                title: "Günlük Seri",
                color: .blue
            )
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Exercise Selection Section
    private var exerciseSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Egzersiz Seçin")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                ForEach(viewModel.exercises) { exercise in
                    BreathingExerciseCard(exercise: exercise)
                        .onTapGesture {
                            print("🎯 Exercise tapped: \(exercise.name)")
                            exerciseState.setExercise(exercise)
                            print("📱 exerciseState.currentExercise set to: \(exerciseState.currentExercise?.name ?? "nil")")
                            showingExerciseDetail = true
                            print("📱 showingExerciseDetail set to: \(showingExerciseDetail)")
                        }
                }
            }
        }
    }
}

// MARK: - Statistic Item
struct StatisticItem: View {
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Breathing Exercise Card
struct BreathingExerciseCard: View {
    let exercise: BreathingExercise
    
    var body: some View {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(exercise.iconColor)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: exercise.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(exercise.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(exercise.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text(exercise.rhythm)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(exercise.cycles)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Benefits
                    HStack(spacing: 8) {
                        ForEach(exercise.benefits, id: \.self) { benefit in
                            Text(benefit)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview
struct BreathingView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingView()
    }
} 
