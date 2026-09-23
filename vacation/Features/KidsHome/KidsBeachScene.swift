import SwiftUI

struct KidsBeachScene: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion || scenePhase != .active)) { timeline in
            let time = reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
            GeometryReader { geometry in
                let width = geometry.size.width
                let progress = reduceMotion ? 0.55 : time.truncatingRemainder(dividingBy: 24) / 24
                let planeX = -85 + (width + 170) * progress
                let planeY = 98 - 65 * sin(progress * .pi)
                ZStack {
                    Canvas { context, size in
                        let w = size.width
                        // Sun, soft cloud banks, and the ocean are kept behind the flight path.
                        context.fill(Path(ellipseIn: CGRect(x: w - 89, y: 18, width: 53, height: 53)), with: .color(Color(red: 1, green: 0.78, blue: 0.33)))
                        for index in 0..<3 {
                            let drift = sin(time / 9 + Double(index) * 2) * 9
                            let x = CGFloat(index) * w * 0.4 - 20 + drift
                            let y = CGFloat(index % 2) * 31 + 40
                            var cloud = Path(roundedRect: CGRect(x: x, y: y, width: 82, height: 21), cornerRadius: 11)
                            cloud.addEllipse(in: CGRect(x: x + 16, y: y - 14, width: 32, height: 32))
                            cloud.addEllipse(in: CGRect(x: x + 37, y: y - 8, width: 30, height: 26))
                            context.fill(cloud, with: .color(.white.opacity(0.75)))
                        }
                        var route = Path()
                        route.move(to: CGPoint(x: 0, y: 98))
                        route.addQuadCurve(to: CGPoint(x: w, y: 95), control: CGPoint(x: w / 2, y: -16))
                        context.stroke(route, with: .color(.white.opacity(0.7)), style: StrokeStyle(lineWidth: 2, dash: [3, 7]))

                        var water = Path()
                        water.move(to: CGPoint(x: 0, y: 148))
                        water.addCurve(to: CGPoint(x: w, y: 139), control1: CGPoint(x: w * 0.3, y: 127), control2: CGPoint(x: w * 0.65, y: 165))
                        water.addLine(to: CGPoint(x: w, y: 245))
                        water.addLine(to: CGPoint(x: 0, y: 245))
                        water.closeSubpath()
                        context.fill(water, with: .linearGradient(Gradient(colors: [Color(red: 0.25, green: 0.73, blue: 0.73), Color(red: 0.13, green: 0.57, blue: 0.64)]), startPoint: CGPoint(x: 0, y: 140), endPoint: CGPoint(x: 0, y: 245)))
                        for index in 0..<4 {
                            let x = Double(index) * 95 + 15 + sin(time / 5) * 4
                            let line = Path(roundedRect: CGRect(x: x, y: 164 + Double(index % 2) * 13, width: 35, height: 2), cornerRadius: 1)
                            context.fill(line, with: .color(.white.opacity(0.5)))
                        }
                        var sand = Path()
                        sand.move(to: CGPoint(x: 0, y: 211))
                        sand.addCurve(to: CGPoint(x: w, y: 210), control1: CGPoint(x: w * 0.5, y: 145), control2: CGPoint(x: w * 0.8, y: 252))
                        sand.addLine(to: CGPoint(x: w, y: 245))
                        sand.addLine(to: CGPoint(x: 0, y: 245))
                        sand.closeSubpath()
                        context.fill(sand, with: .color(Color(red: 1, green: 0.86, blue: 0.62)))
                    }
                    SurpriseAirplane()
                        .scaleEffect(0.53)
                        .rotationEffect(.degrees(-cos(progress * .pi) * 12))
                        .position(x: planeX, y: planeY)
                        .shadow(color: .teal.opacity(0.15), radius: 4, y: 4)
                    Image(systemName: "beach.umbrella.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(red: 0.89, green: 0.34, blue: 0.24), Color(red: 0.58, green: 0.35, blue: 0.19))
                        .font(.system(size: 65))
                        .rotationEffect(.degrees(-10))
                        .position(x: width * 0.24, y: 186)
                    Image(systemName: "star.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color(red: 0.87, green: 0.38, blue: 0.23))
                        .rotationEffect(.degrees(15))
                        .position(x: width * 0.72, y: 224)
                    ForEach(0..<3) { index in
                        Image(systemName: "sparkle")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(red: 0.7, green: 0.47, blue: 0.13))
                            .opacity(reduceMotion ? 0.7 : 0.45 + 0.3 * sin(time / 2 + Double(index) * 2))
                            .scaleEffect(reduceMotion ? 1 : 1 + 0.08 * sin(time / 3 + Double(index)))
                            .position(x: width * (0.18 + Double(index) * 0.31), y: index == 1 ? 18 : 100)
                    }
                }
            }
        }
        .clipped()
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}
