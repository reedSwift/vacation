import SwiftUI

/// A friendly side-view toy jet, facing in the direction of the flyover.
struct SurpriseAirplane: View {
    private let coral = Color(red: 0.94, green: 0.37, blue: 0.27)
    private let teal = Color(red: 0.08, green: 0.35, blue: 0.4)

    var body: some View {
        ZStack {
            // Far wing and upright tail sit behind the cabin.
            Path { path in
                path.move(to: CGPoint(x: 80, y: 58))
                path.addLine(to: CGPoint(x: 61, y: 20))
                path.addQuadCurve(to: CGPoint(x: 76, y: 21), control: CGPoint(x: 70, y: 16))
                path.addLine(to: CGPoint(x: 120, y: 60))
                path.closeSubpath()
            }
            .fill(coral.opacity(0.85))

            Path { path in
                path.move(to: CGPoint(x: 27, y: 65))
                path.addLine(to: CGPoint(x: 12, y: 14))
                path.addQuadCurve(to: CGPoint(x: 29, y: 12), control: CGPoint(x: 18, y: 7))
                path.addLine(to: CGPoint(x: 66, y: 63))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: [Color(red: 1, green: 0.83, blue: 0.39), Color(red: 0.98, green: 0.63, blue: 0.23)], startPoint: .top, endPoint: .bottom))

            Image(systemName: "star.fill")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .position(x: 30, y: 32)

            Path { path in
                path.move(to: CGPoint(x: 18, y: 57))
                path.addQuadCurve(to: CGPoint(x: 134, y: 46), control: CGPoint(x: 70, y: 39))
                path.addCurve(to: CGPoint(x: 178, y: 69), control1: CGPoint(x: 156, y: 46), control2: CGPoint(x: 174, y: 55))
                path.addQuadCurve(to: CGPoint(x: 149, y: 87), control: CGPoint(x: 187, y: 86))
                path.addLine(to: CGPoint(x: 65, y: 87))
                path.addQuadCurve(to: CGPoint(x: 18, y: 57), control: CGPoint(x: 35, y: 84))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: [.white, Color(red: 1, green: 0.96, blue: 0.84), Color(red: 0.9, green: 0.8, blue: 0.62)], startPoint: .top, endPoint: .bottom))
            .overlay {
                Capsule().fill(coral).frame(width: 93, height: 5).position(x: 102, y: 77)
            }

            HStack(spacing: 6) {
                ForEach(0..<4) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(teal.gradient)
                        .frame(width: 10, height: 12)
                        .overlay(alignment: .topLeading) {
                            Capsule().fill(.white.opacity(0.65)).frame(width: 3, height: 5).padding(2)
                        }
                }
            }
            .position(x: 98, y: 60)

            Path { path in
                path.move(to: CGPoint(x: 145, y: 51))
                path.addQuadCurve(to: CGPoint(x: 165, y: 61), control: CGPoint(x: 157, y: 52))
                path.addLine(to: CGPoint(x: 146, y: 61))
                path.closeSubpath()
            }
            .fill(teal)

            // Near wing projects below the body for a readable airplane silhouette.
            Path { path in
                path.move(to: CGPoint(x: 85, y: 74))
                path.addLine(to: CGPoint(x: 130, y: 75))
                path.addLine(to: CGPoint(x: 81, y: 117))
                path.addQuadCurve(to: CGPoint(x: 61, y: 116), control: CGPoint(x: 69, y: 122))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: [Color(red: 1, green: 0.57, blue: 0.39), coral], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay {
                Capsule().fill(teal).frame(width: 29, height: 14)
                    .overlay(alignment: .trailing) { Ellipse().fill(Color(red: 0.04, green: 0.21, blue: 0.27)).frame(width: 7, height: 10).padding(.trailing, 2) }
                    .position(x: 111, y: 96)
            }
        }
        .frame(width: 190, height: 130)
        .accessibilityHidden(true)
    }
}
