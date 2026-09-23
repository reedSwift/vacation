import SwiftUI

struct KidsCountdownHeroView: View {
    let startDate: Date
    @ScaledMetric(relativeTo: .largeTitle) private var numberSize = 112
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TimelineView(.everyMinute) { timeline in
            // Scene changes also refresh the date immediately after returning to the app.
            let now = scenePhase == .active ? max(timeline.date, Date.now) : timeline.date
            let sleeps = VacationCountdown.sleeps(until: startDate, now: now)
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text(sleeps, format: .number)
                        .font(.system(size: numberSize, weight: .heavy, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundStyle(Color(red: 0.09, green: 0.32, blue: 0.38))
                    Text("SLEEPS!")
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .tracking(3)
                        .foregroundStyle(Color(red: 0.69, green: 0.25, blue: 0.17))
                    Text("Until our VACATION!")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color(red: 0.09, green: 0.32, blue: 0.38))
                        .padding(.top, 12)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.top, 30)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(sleeps) \(sleeps == 1 ? "sleep" : "sleeps") until our Vacation!")
                .accessibilityAddTraits(.isHeader)

                KidsBeachScene()
                    .frame(height: 245)
            }
            .background(LinearGradient(colors: [Color(red: 1, green: 0.97, blue: 0.86), Color(red: 0.76, green: 0.92, blue: 0.92)], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 36))
            .overlay { RoundedRectangle(cornerRadius: 36).stroke(.white.opacity(0.8), lineWidth: 1) }
            .shadow(color: Color.teal.opacity(0.1), radius: 18, y: 9)
        }
    }
}
