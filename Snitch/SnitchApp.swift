import SwiftUI

@main
struct SnitchApp: App {
    @StateObject private var feedViewModel = FeedViewModel()
    @StateObject private var goalsViewModel = GoalsViewModel()
    @StateObject private var groupsViewModel = GroupsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(feedViewModel)
                .environmentObject(goalsViewModel)
                .environmentObject(groupsViewModel)
        }
    }
}
