import SwiftUI

enum KidsActivity: String, CaseIterable, Identifiable {
    case packing = "Pack My Suitcase"
    case stickers = "My Stickers"
    case adventure = "My Adventure"
    case treasures = "My Treasures"

    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .packing: "🧳"
        case .stickers: "⭐"
        case .adventure: "✈️"
        case .treasures: "✨"
        }
    }
    var color: Color {
        switch self {
        case .packing: .orange
        case .stickers: .yellow
        case .adventure: .teal
        case .treasures: .purple
        }
    }
}

struct KidsActivityPlaceholder: View {
    let activity: KidsActivity

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(activity.emoji).font(.system(size: 88)).accessibilityHidden(true)
                Text(activity.rawValue)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .accessibilityAddTraits(.isHeader)
                Text("A little more magic is coming soon!")
                    .font(.system(.title3, design: .rounded))
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(Color(red: 0.08, green: 0.26, blue: 0.34))
            .padding(32)
            .padding(.top, 60)
            .frame(maxWidth: .infinity)
        }
        .background { BeachBackground() }
        .navigationTitle(activity.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
