import SwiftUI
import SwiftData

struct KidsHomeView: View {
    var onReplaySurprise: () -> Void = {}
    @Query(sort: \Trip.startDate) private var trips: [Trip]
    @State private var path: [KidsActivity] = []

    var body: some View {
        NavigationStack(path: $path) {
            KidsHomeContent(trip: trips.first)
            .navigationTitle("OurTrip")
            .navigationBarTitleDisplayMode(.inline)
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Replay surprise", systemImage: "arrow.counterclockwise", action: onReplaySurprise)
                        .labelStyle(.iconOnly)
                        .accessibilityHint("Development control. Shows Olivia’s surprise again.")
                }
            }
            #endif
            .navigationDestination(for: KidsActivity.self) { activity in
                KidsActivityPlaceholder(activity: activity)
            }
        }
        .sensoryFeedback(.selection, trigger: path)
    }
}

// Keep the scroll content behind a concrete View boundary so the navigation
// modifier chain does not carry the entire screen’s nested generic value.
private struct KidsHomeContent: View {
    let trip: Trip?

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("OLIVIA’S LITTLE GETAWAY")
                            .font(.caption.weight(.heavy))
                            .tracking(2)
                        Text("Adventure awaits!")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .accessibilityAddTraits(.isHeader)
                    }
                    .padding(.top, 16)

                    if let trip {
                        KidsCountdownHeroView(startDate: trip.startDate)
                    } else {
                        ContentUnavailableView("An adventure is on its way", systemImage: "sun.max.fill", description: Text("Your vacation will appear here soon."))
                    }

                    DailyMissionsSection()

                    StarJourneyView()

                    ForEach(KidsActivity.allCases) { activity in
                        NavigationLink(value: activity) {
                            HStack(spacing: 16) {
                                Text(activity.emoji)
                                    .font(.system(size: 34))
                                    .frame(width: 60, height: 60)
                                    .background(activity.color.opacity(0.14), in: RoundedRectangle(cornerRadius: 20))
                                    .accessibilityHidden(true)
                                Text(activity.rawValue)
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.right")
                                    .font(.body.bold())
                                    .accessibilityHidden(true)
                            }
                            .padding(16)
                            .background(.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 28))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .foregroundStyle(Color(red: 0.08, green: 0.26, blue: 0.34))
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
            .background { BeachBackground() }
    }
}
