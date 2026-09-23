import SwiftUI

enum DailyMission: String, CaseIterable, Identifiable {
    case morningBrush, nightBrush, bathTime, nightPants
    var id: String { rawValue }
    var name: String {
        switch self {
        case .morningBrush: "Morning Brush"
        case .nightBrush: "Night Brush"
        case .bathTime: "Bath Time"
        case .nightPants: "Night Pants"
        }
    }
    var emoji: String {
        switch self {
        case .morningBrush: "☀️"
        case .nightBrush: "🌙"
        case .bathTime: "🛁"
        case .nightPants: "🩳"
        }
    }
    var tint: Color {
        switch self {
        case .morningBrush: .orange
        case .nightBrush: .indigo
        case .bathTime: .teal
        case .nightPants: .purple
        }
    }
}
