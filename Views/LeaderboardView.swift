import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel

    var body: some View {
        NavigationStack {
            List {
                let ranked = viewModel.ranked(
                    from: usersViewModel.users,
                    memberIds: groupsViewModel.activeGroup?.memberIds ?? []
                )
                ForEach(Array(ranked.enumerated()), id: \.element.id) { index, user in
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
