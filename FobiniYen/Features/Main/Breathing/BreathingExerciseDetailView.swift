import SwiftUI

struct BreathingExerciseDetailView: View {
    
    // MARK: - Properties
    let exercise: BreathingExercise
    @StateObject private var viewModel = BreathingExerciseDetailViewModel()
    @Environment(\.presentationMode) var presentationMode
    var onExerciseCompleted: (() -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                headerSection
                
                Spacer()
                
                // Breathing Circle
                breathingCircleSection
                
                Spacer()
                
                // Controls
                controlsSection
                
                // Benefits
                benefitsSection
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationBarHidden(true)
        .onAppear {
            if let callback = onExerciseCompleted {
                viewModel.onExerciseCompleted = callback
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                    Text("Geri")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text("Döngü \(viewModel.currentCycle)/\(viewModel.totalCycles)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Breathing Circle Section
    private var breathingCircleSection: some View {
        VStack(spacing: 20) {
            Text(exercise.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(exercise.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            // Breathing Circle
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: viewModel.circleSize, height: viewModel.circleSize)
                    .scaleEffect(viewModel.circleScale)
                    .animation(.easeInOut(duration: viewModel.breathingDuration), value: viewModel.circleScale)
                
                Text(viewModel.breathingInstruction)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.primary)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.breathingInstruction)
            }
            
            Text("Toplam süre: \(viewModel.formattedTime)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Controls Section
    private var controlsSection: some View {
        HStack(spacing: 16) {
            Button(action: {
                viewModel.toggleExercise()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: viewModel.isActive ? "pause.fill" : "play.fill")
                        .font(.system(size: 18, weight: .medium))
                    Text(viewModel.isActive ? "Duraklat" : "Başlat")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.black)
                .cornerRadius(12)
            }
            
            Button(action: {
                viewModel.resetExercise()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18, weight: .medium))
                    Text("Sıfırla")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Benefits Section
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Faydaları")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(exercise.benefits, id: \.self) { benefit in
                    Text(benefit)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview
struct BreathingExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingExerciseDetailView(
            exercise: BreathingExercise(
                id: "4-7-8",
                name: "4-7-8 Nefes Tekniği",
                description: "Anksiyeteyi azaltan ve uykuyu destekleyen sakinleştirici teknik",
                rhythm: "4-7-8 ritmi",
                cycles: "4 döngü",
                icon: "wind",
                iconColor: .blue,
                benefits: ["Anksiyeteyi azaltır", "Gevşeme sağlar", "Uykuyu iyileştirir", "Stresi düşürür"]
            )
        )
    }
} 