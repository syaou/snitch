import SwiftUI

@main
struct SnitchApp: App {
    @StateObject private var feedViewModel = FeedViewModel()
    @StateObject private var goalsViewModel = GoalsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(feedViewModel)
                .environmentObject(goalsViewModel)
        }
    }
}
