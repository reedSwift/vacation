import SwiftUI

struct CelebrationConfetti: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var startedAt = Date.now
    @State private var finished = false
    private let colors: [Color] = [.pink, .orange, .yellow, .teal, .cyan, .purple]

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: finished)) { timeline in
            Canvas { context, size in
                let elapsed = max(0, timeline.date.timeIntervalSince(startedAt))
                let fade = min(1, max(0, (3.2 - elapsed) / 0.7))
                for index in 0..<48 {
                    let seed = Double(index)
                    let delay = Double(index % 8) * 0.045
                    let age = max(0, elapsed - delay)
                    guard elapsed >= delay else { continue }
                    let spread = Double((index * 37) % 101) / 100
                    let x: Double
                    let y: Double
                    if reduceMotion {
                        x = size.width * (0.04 + spread * 0.92)
                        y = size.height * Double((index * 23) % 97) / 100
                    } else {
                        // Two cheerful bursts fan out from the upper corners, then drift down.
                        let fromLeft = index.isMultiple(of: 2)
                        let origin = fromLeft ? size.width * 0.08 : size.width * 0.92
                        let speed = (35 + spread * size.width * 0.38) * (fromLeft ? 1 : -1)
                        x = origin + speed * age + sin(age * 3 + seed) * 9
                        y = size.height * 0.12 - (55 + Double(index % 5) * 16) * age + 115 * age * age
                    }
                    var particle = context
                    particle.opacity = fade * (reduceMotion ? 0.65 : 0.95)
                    particle.translateBy(x: x, y: y)
                    particle.rotate(by: .degrees(reduceMotion ? seed * 27 : seed * 27 + age * 140))
                    let rect = CGRect(x: -4, y: -6, width: index.isMultiple(of: 3) ? 7 : 9, height: index.isMultiple(of: 3) ? 7 : 13)
                    let shape = index.isMultiple(of: 3) ? Path(ellipseIn: rect) : Path(roundedRect: rect, cornerRadius: 2)
                    particle.fill(shape, with: .color(colors[index % colors.count]))
                }
            }
        }
        .task {
            startedAt = .now
            do {
                try await Task.sleep(for: .seconds(3.3))
                finished = true
            } catch { }
        }
        .opacity(finished ? 0 : 1)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
