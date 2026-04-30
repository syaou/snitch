import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
                    LeaderboardRowView(user: user, rank: index + 1)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Leaderboard")
        }
    }
}
