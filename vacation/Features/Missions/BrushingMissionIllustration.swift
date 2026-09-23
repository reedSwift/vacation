import SwiftUI

/// A smiling tooth and side-on toothbrush, readable at the card's small size.
struct BrushingMissionIllustration: View {
    let isMorning: Bool
    let isComplete: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase

    private var handleColor: Color {
        isMorning ? Color(red: 0.94, green: 0.43, blue: 0.28) : Color(red: 0.48, green: 0.43, blue: 0.77)
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20, paused: reduceMotion || isComplete || scenePhase != .active)) { timeline in
            let motion = reduceMotion || isComplete ? 0 : sin(timeline.date.timeIntervalSinceReferenceDate * 3)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.83, green: 0.94, blue: 0.95))

                tooth
                    .fill(LinearGradient(colors: [.white, Color(red: 0.94, green: 0.98, blue: 1)], startPoint: .top, endPoint: .bottom))
                    .overlay { tooth.stroke(Color(red: 0.48, green: 0.74, blue: 0.78), lineWidth: 1.2) }
                    .frame(width: 34, height: 39)
                    .position(x: 29, y: 29)

                HStack(spacing: 9) {
                    Capsule().frame(width: 2.5, height: 4)
                    Capsule().frame(width: 2.5, height: 4)
                }
                .foregroundStyle(Color(red: 0.12, green: 0.35, blue: 0.41))
                .position(x: 29, y: 25)

                Path { path in
                    path.move(to: CGPoint(x: 25, y: 30))
                    path.addQuadCurve(to: CGPoint(x: 33, y: 30), control: CGPoint(x: 29, y: 36))
                }
                .stroke(Color(red: 0.12, green: 0.35, blue: 0.41), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))

                Text(isMorning ? "☀️" : "🌙")
                    .font(.system(size: 14))
                    .position(x: 51, y: 10)

                toothbrush
                    .rotationEffect(.degrees(-16))
                    .offset(x: motion * 3, y: 0)
                    .position(x: 39, y: 44)

                ForEach(0..<3) { index in
                    Circle()
                        .fill(.white.opacity(0.95))
                        .overlay { Circle().stroke(Color.teal.opacity(0.3), lineWidth: 0.7) }
                        .frame(width: index == 1 ? 5 : 3.5, height: index == 1 ? 5 : 3.5)
                        .position(x: 13 + Double(index) * 5, y: 35 - Double(index % 2) * 5)
                        .opacity(reduceMotion || isComplete ? 1 : 0.8 + motion * 0.2)
                }
            }
        }
        .frame(width: 60, height: 60)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private var toothbrush: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(handleColor.gradient)
                .frame(width: 43, height: 6)
                .overlay(alignment: .trailing) {
                    Capsule().fill(.white.opacity(0.6)).frame(width: 12, height: 2).padding(.trailing, 5)
                }
            HStack(spacing: 1) {
                ForEach(0..<6) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color(red: 0.12, green: 0.6, blue: 0.65))
                        .frame(width: 2, height: 7)
                }
            }
            .padding(.leading, 2)
            .offset(y: -5)
        }
        .frame(width: 43, height: 14)
    }

    private var tooth: Path {
        Path { path in
            path.move(to: CGPoint(x: 17, y: 3))
            path.addCurve(to: CGPoint(x: 1, y: 13), control1: CGPoint(x: -1, y: -7), control2: CGPoint(x: -1, y: 4))
            path.addCurve(to: CGPoint(x: 7, y: 37), control1: CGPoint(x: 3, y: 22), control2: CGPoint(x: 2, y: 37))
            path.addCurve(to: CGPoint(x: 17, y: 25), control1: CGPoint(x: 13, y: 42), control2: CGPoint(x: 11, y: 25))
            path.addCurve(to: CGPoint(x: 27, y: 37), control1: CGPoint(x: 23, y: 25), control2: CGPoint(x: 21, y: 42))
            path.addCurve(to: CGPoint(x: 33, y: 13), control1: CGPoint(x: 32, y: 37), control2: CGPoint(x: 31, y: 22))
            path.addCurve(to: CGPoint(x: 17, y: 3), control1: CGPoint(x: 35, y: 4), control2: CGPoint(x: 35, y: -7))
            path.closeSubpath()
        }
    }
}
