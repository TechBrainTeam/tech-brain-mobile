import SwiftUI

struct UserProgressView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("İlerlemeniz")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Korkularınızı yenme yolculuğunuzu takip edin")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Tab Selector
                    HStack(spacing: 0) {
                        ForEach(["Genel Bakış", "İstatistikler", "Ödüller"], id: \.self) { tab in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = ["Genel Bakış", "İstatistikler", "Ödüller"].firstIndex(of: tab) ?? 0
                                }
                            }) {
                                Text(tab)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedTab == ["Genel Bakış", "İstatistikler", "Ödüller"].firstIndex(of: tab) ? .primary : .secondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedTab == ["Genel Bakış", "İstatistikler", "Ödüller"].firstIndex(of: tab) ? Color(.systemGray6) : Color.clear)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Content based on selected tab
                    switch selectedTab {
                    case 0:
                        OverviewTabView()
                    case 1:
                        StatisticsTabView()
                    case 2:
                        RewardsTabView()
                    default:
                        OverviewTabView()
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

struct OverviewTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 7-Day Streak Card
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("7 Günlük Seri!")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Böyle devam!")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text("🔥")
                    .font(.system(size: 32))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.1), Color.orange.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            
            // This Week Summary
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text("Bu Hafta")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                // Metrics
                HStack(spacing: 20) {
                    MetricCard(value: "23", label: "Seans", color: .primary)
                    MetricCard(value: "3.9/10", label: "Ort. Anksiyete", color: .green)
                    MetricCard(value: "85%", label: "Hedef", color: .blue)
                }
                
                // Weekly Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Günlük tamamlanan seanslar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { day in
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.black)
                                    .frame(width: 20, height: getBarHeight(for: day))
                                
                                Text(day)
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Current Goals
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.purple)
                    Text("Mevcut Hedefler")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                VStack(spacing: 12) {
                    GoalProgressCard(title: "Günlük nefes egzersizi", progress: 5, total: 7, color: .blue)
                    GoalProgressCard(title: "Maruz kalma seviye 3'ü tamamla", progress: 60, total: 100, color: .green)
                    GoalProgressCard(title: "5 fobi hakkında öğren", progress: 4, total: 5, color: .orange)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
    
    private func getBarHeight(for day: String) -> CGFloat {
        let heights: [String: CGFloat] = [
            "Pzt": 30, "Sal": 20, "Çar": 50, "Per": 25,
            "Cum": 35, "Cmt": 45, "Paz": 15
        ]
        return heights[day] ?? 20
    }
}

struct StatisticsTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            // All-Time Statistics
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.blue)
                    Text("Tüm Zamanlar İstatistikleri")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    StatCard(value: "156", label: "Toplam Seans", color: .blue)
                    StatCard(value: "42s", label: "Pratik Süresi", color: .green)
                    StatCard(value: "12", label: "Keşfedilen Fobi", color: .purple)
                    StatCard(value: "28", label: "Aktif Gün", color: .orange)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Anxiety Level Trends
            VStack(alignment: .leading, spacing: 16) {
                Text("Anksiyete Seviyesi Trendleri")
                    .font(.system(size: 18, weight: .semibold))
                
                VStack(spacing: 12) {
                    TrendProgressCard(title: "Bu hafta ort.", value: 3.9, progress: 0.7, color: .green)
                    TrendProgressCard(title: "Geçen hafta ort.", value: 4.2, progress: 0.8, color: .orange)
                    TrendProgressCard(title: "Bir ay önce ort.", value: 5.8, progress: 0.95, color: .red)
                }
                
                HStack {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.red)
                    Text("Harika ilerleme! Anksiyete seviyeleriniz bu ay %35 azaldı.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Session Distribution
            VStack(alignment: .leading, spacing: 16) {
                Text("Seans Dağılımı")
                    .font(.system(size: 18, weight: .semibold))
                
                VStack(spacing: 12) {
                    DistributionCard(title: "Nefes egzersizleri", percentage: 60, color: .blue)
                    DistributionCard(title: "Maruz kalma terapisi", percentage: 30, color: .green)
                    DistributionCard(title: "Öğrenme seansları", percentage: 10, color: .purple)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
}

struct RewardsTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Achievements Summary
            VStack(spacing: 16) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                
                Text("Başarımlar")
                    .font(.system(size: 20, weight: .bold))
                
                Text("2 / 5 açıldı")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                ProgressView(value: 0.4)
                    .progressViewStyle(LinearProgressViewStyle(tint: .black))
                    .scaleEffect(y: 2)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Individual Achievements
            VStack(spacing: 12) {
                AchievementCard(
                    icon: "star.fill",
                    title: "İlk Adımlar",
                    description: "İlk nefes egzersizirinizi tamamlayın",
                    isCompleted: true
                )
                
                AchievementCard(
                    icon: "flame.fill",
                    title: "Hafta Savaşçısı",
                    description: "Uygulamayı 7 gün üst üste kullanın",
                    isCompleted: true
                )
                
                AchievementCard(
                    icon: "target",
                    title: "Maruz Kalma Uzmanı",
                    description: "5 maruz kalma terapisi seansını tamamlayın",
                    progress: 3,
                    total: 5,
                    isCompleted: false
                )
                
                AchievementCard(
                    icon: "ribbon",
                    title: "Nefes Ustası",
                    description: "50 nefes egzersizi tamamlayın",
                    progress: 23,
                    total: 50,
                    isCompleted: false
                )
            }
        }
    }
}

// MARK: - Helper Views
struct MetricCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct GoalProgressCard: View {
    let title: String
    let progress: Int
    let total: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
                
                Text("\(progress)/\(total)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: Double(progress) / Double(total))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}

struct TrendProgressCard: View {
    let title: String
    let value: Double
    let progress: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(width: 100)
            
            Text(String(format: "%.1f", value))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
        }
    }
}

struct DistributionCard: View {
    let title: String
    let percentage: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
            
            ProgressView(value: Double(percentage) / 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(width: 100)
            
            Text("\(percentage)%")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
        }
    }
}

struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    var progress: Int?
    var total: Int?
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isCompleted ? .yellow : .gray)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isCompleted ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isCompleted ? .primary : .secondary)
                
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                if let progress = progress, let total = total, !isCompleted {
                    HStack {
                        ProgressView(value: Double(progress) / Double(total))
                            .progressViewStyle(LinearProgressViewStyle(tint: .gray))
                            .frame(width: 80)
                        
                        Text("\(progress)/\(total)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if isCompleted {
                Text("Açıldı")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(isCompleted ? Color.yellow.opacity(0.05) : Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    UserProgressView()
} 
