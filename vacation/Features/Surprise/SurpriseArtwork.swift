import SwiftUI

/// A layered paper-and-ribbon illustration, drawn natively at any resolution.
struct SurpriseArtwork: View {
    let isOpening: Bool
    let reduceMotion: Bool

    private let coral = Color(red: 0.94, green: 0.39, blue: 0.3)
    private let gold = Color(red: 1, green: 0.78, blue: 0.36)

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [.white, Color(red: 1, green: 0.9, blue: 0.69).opacity(0.5), .clear], center: .center, startRadius: 30, endRadius: 155))
                .frame(width: 310, height: 310)
            Circle()
                .stroke(.white.opacity(0.7), style: StrokeStyle(lineWidth: 1, dash: [3, 8]))
                .frame(width: 260, height: 260)
            Ellipse()
                .fill(Color(red: 0.56, green: 0.39, blue: 0.24).opacity(0.13))
                .frame(width: 190, height: 22)
                .blur(radius: 9)
                .offset(y: 115)

            ForEach(0..<8) { index in
                let angle = Double(index) * .pi / 4
                Image(systemName: index.isMultiple(of: 2) ? "sparkle" : "circle.fill")
                    .font(.system(size: index.isMultiple(of: 2) ? 20 : 7, weight: .medium))
                    .foregroundStyle(index.isMultiple(of: 3) ? coral : Color(red: 0.72, green: 0.49, blue: 0.13))
                    .offset(x: cos(angle) * (isOpening && !reduceMotion ? 150 : 125),
                            y: sin(angle) * (isOpening && !reduceMotion ? 145 : 118))
            }

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [coral, Color(red: 0.79, green: 0.24, blue: 0.23)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 18).fill(.white.opacity(0.08)).frame(width: 16)
                    }
                    .frame(width: 172, height: 140)
                    .overlay {
                        Rectangle().fill(gold.gradient).frame(width: 30)
                    }
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(.black.opacity(0.06)).frame(height: 7).padding(.horizontal, 16)
                    }
                    .offset(y: 32)

                VStack(spacing: -4) {
                    HStack(spacing: -3) {
                        ribbonLoop.rotationEffect(.degrees(25))
                        ribbonLoop.rotationEffect(.degrees(-25))
                    }
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(colors: [Color(red: 1, green: 0.55, blue: 0.4), coral], startPoint: .top, endPoint: .bottom))
                        .frame(width: 194, height: 36)
                        .overlay { Rectangle().fill(gold.gradient).frame(width: 32) }
                        .overlay(alignment: .top) { Capsule().fill(.white.opacity(0.35)).frame(height: 2).padding(.horizontal, 9) }
                        .shadow(color: .black.opacity(0.13), radius: 3, y: 5)
                }
                .offset(y: isOpening && !reduceMotion ? -96 : -52)
                .rotationEffect(.degrees(isOpening && !reduceMotion ? -14 : 0))

                Text("O")
                    .font(.system(size: 25, weight: .bold, design: .serif))
                    .foregroundStyle(Color(red: 0.55, green: 0.29, blue: 0.2))
                    .frame(width: 43, height: 52)
                    .background(Color(red: 1, green: 0.96, blue: 0.85), in: RoundedRectangle(cornerRadius: 9))
                    .overlay(alignment: .top) { Circle().fill(coral).frame(width: 4, height: 4).padding(.top, 5) }
                    .rotationEffect(.degrees(12))
                    .offset(x: 47, y: 12)
            }
            .rotationEffect(.degrees(-5))
            .scaleEffect(isOpening ? 1.04 : 1)
        }
        .frame(width: 310, height: 310)
        .animation(reduceMotion ? .easeInOut(duration: 0.2) : .spring(response: 0.5, dampingFraction: 0.65), value: isOpening)
        .accessibilityHidden(true)
    }

    private var ribbonLoop: some View {
        Ellipse()
            .stroke(gold.gradient, lineWidth: 12)
            .frame(width: 52, height: 29)
            .overlay { Ellipse().stroke(.white.opacity(0.3), lineWidth: 2).padding(2) }
    }
}

struct SurpriseBackdrop: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [Color(red: 1, green: 0.97, blue: 0.88), Color(red: 1, green: 0.93, blue: 0.8), Color(red: 0.8, green: 0.92, blue: 0.88)], startPoint: .top, endPoint: .bottom)
                Circle()
                    .fill(Color.white.opacity(0.45))
                    .frame(width: 190, height: 190)
                    .blur(radius: 20)
                    .offset(x: geometry.size.width * 0.36, y: -geometry.size.height * 0.3)
                Ellipse()
                    .fill(Color(red: 0.43, green: 0.74, blue: 0.72).opacity(0.14))
                    .frame(width: geometry.size.width * 1.8, height: 260)
                    .rotationEffect(.degrees(-12))
                    .position(x: geometry.size.width * 0.3, y: geometry.size.height + 40)
                Ellipse()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: geometry.size.width * 1.7, height: 200)
                    .rotationEffect(.degrees(13))
                    .position(x: geometry.size.width * 0.7, y: geometry.size.height + 50)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct SurpriseButtonStyle: ButtonStyle {
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(reduceMotion ? nil : .spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
