import SwiftUI

/// Training pants with a waistband and two leg openings; the moon is only an accent.
struct NightPantsIllustration: View {
    private let lavender = Color(red: 0.58, green: 0.49, blue: 0.8)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(lavender.opacity(0.13))
            Path { path in
                path.move(to: CGPoint(x: 9, y: 18))
                path.addQuadCurve(to: CGPoint(x: 51, y: 18), control: CGPoint(x: 30, y: 22))
                path.addLine(to: CGPoint(x: 47, y: 43))
                path.addQuadCurve(to: CGPoint(x: 34, y: 49), control: CGPoint(x: 45, y: 51))
                path.addLine(to: CGPoint(x: 30, y: 39))
                path.addLine(to: CGPoint(x: 26, y: 49))
                path.addQuadCurve(to: CGPoint(x: 13, y: 43), control: CGPoint(x: 15, y: 51))
                path.closeSubpath()
            }
            .fill(LinearGradient(colors: [.white, Color(red: 0.84, green: 0.81, blue: 0.96)], startPoint: .top, endPoint: .bottom))
            Path { path in
                path.move(to: CGPoint(x: 10, y: 19))
                path.addQuadCurve(to: CGPoint(x: 50, y: 19), control: CGPoint(x: 30, y: 23))
                path.move(to: CGPoint(x: 14, y: 43))
                path.addQuadCurve(to: CGPoint(x: 25, y: 47), control: CGPoint(x: 17, y: 49))
                path.move(to: CGPoint(x: 35, y: 47))
                path.addQuadCurve(to: CGPoint(x: 46, y: 43), control: CGPoint(x: 43, y: 49))
            }
            .stroke(lavender, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundStyle(lavender)
                .position(x: 30, y: 31)
            Image(systemName: "moon.fill")
                .font(.system(size: 11))
                .foregroundStyle(Color(red: 0.79, green: 0.57, blue: 0.15))
                .position(x: 48, y: 9)
        }
        .frame(width: 60, height: 60)
        .accessibilityHidden(true)
    }
}
