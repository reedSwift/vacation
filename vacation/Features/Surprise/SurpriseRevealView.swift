import SwiftUI

struct SurpriseRevealView: View {
    let onOpen: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var sound = SurpriseSound()
    @State private var isOpening = false
    @State private var showAirplane = false
    @State private var airplaneHasArrived = false
    @AccessibilityFocusState private var headlineIsFocused: Bool

    @ScaledMetric(relativeTo: .largeTitle) private var headlineSize = 36

    private let ink = Color(red: 0.08, green: 0.26, blue: 0.34)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SurpriseBackdrop()
                ScrollView {
                    VStack(spacing: 20) {
                        Text("A SPECIAL DELIVERY")
                            .font(.caption.weight(.heavy))
                            .tracking(3)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.6), in: Capsule())
                            .multilineTextAlignment(.center)

                        (Text("Olivia,\n").foregroundColor(Color(red: 0.73, green: 0.28, blue: 0.2)) + Text("Daddy has a surprise for you…"))
                            .font(.system(size: headlineSize, weight: .bold, design: .rounded))
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityLabel("Olivia, Daddy has a surprise for you…")
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)
                            .accessibilityFocused($headlineIsFocused)

                        SurpriseArtwork(isOpening: isOpening, reduceMotion: reduceMotion)
                            .frame(maxWidth: .infinity)

                        Text(isOpening ? "Here comes our adventure!" : "A little box. A big adventure.")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .multilineTextAlignment(.center)

                        Button {
                            guard !isOpening else { return }
                            isOpening = true
                        } label: {
                            Text("OPEN MY SURPRISE")
                                .font(.system(.title3, design: .rounded, weight: .heavy))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .padding(20)
                                .foregroundStyle(.white)
                                .background(
                                    LinearGradient(colors: [Color(red: 0.13, green: 0.4, blue: 0.41), Color(red: 0.07, green: 0.28, blue: 0.31)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    in: RoundedRectangle(cornerRadius: 28)
                                )
                                .overlay { RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.3), lineWidth: 1).padding(1) }
                                .shadow(color: ink.opacity(0.18), radius: 14, y: 8)
                        }
                        .buttonStyle(SurpriseButtonStyle(reduceMotion: reduceMotion))
                        .disabled(isOpening)
                        .accessibilityHint("Opens your vacation surprise.")
                    }
                    .foregroundStyle(ink)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 32)
                    .frame(maxWidth: 540)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }

                if showAirplane {
                    SurpriseAirplane()
                        .shadow(color: ink.opacity(0.3), radius: 8, y: 6)
                        .rotationEffect(.degrees(reduceMotion ? 0 : -12))
                        .offset(x: reduceMotion ? 0 : (airplaneHasArrived ? geometry.size.width / 2 + 110 : -geometry.size.width / 2 - 110))
                        .scaleEffect(reduceMotion && !airplaneHasArrived ? 0.9 : 1)
                        .opacity(reduceMotion && !airplaneHasArrived ? 0 : 1)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, geometry.size.height * 0.2)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isOpening)
        .task { headlineIsFocused = true }
        .onDisappear { sound.stop() }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { sound.stop() }
        }
        .task(id: isOpening) {
            guard isOpening else { return }
            sound.play()
            do {
                try await Task.sleep(for: .milliseconds(300))
                showAirplane = true
                try await Task.sleep(for: .milliseconds(30))
                withAnimation(reduceMotion ? .easeInOut(duration: 0.25) : .linear(duration: 2.2)) {
                    airplaneHasArrived = true
                }
                try await Task.sleep(for: .milliseconds(reduceMotion ? 450 : 2300))
                try Task.checkCancellation()
                onOpen()
            } catch {
                // A disappearing view cancels the reveal instead of finishing it off-screen.
            }
        }
    }

}
