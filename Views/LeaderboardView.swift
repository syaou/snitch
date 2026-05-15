import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                let ranked = viewModel.ranked(
                    from: usersViewModel.users,
                    memberIds: groupsViewModel.activeGroup?.memberIds ?? []
                )
                VStack(alignment: .leading, spacing: 14) {
                    header

                    if ranked.isEmpty {
                        emptyState
                    } else {
                        ForEach(Array(ranked.enumerated()), id: \.element.id) { index, user in
                            LeaderboardRowView(user: user, rank: index + 1)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 90)
            }
            .background(AppColours.mustard)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Kicker(text: groupsViewModel.activeGroup?.name ?? "Active group")

                    Text("Leaderboard")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(AppColours.ink)
                }

                Spacer()
            }

            prizeCard
        }
    }

    private var prizeCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "gift.fill")
                .font(.headline.weight(.black))
                .foregroundStyle(AppColours.ink)
                .frame(width: 42, height: 42)
                .background(AppColours.mustard)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppColours.ink, lineWidth: 1.2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 5) {
                Text("Winner gets")
                    .font(.caption.weight(.black))
                    .foregroundStyle(AppColours.muted)
                    .textCase(.uppercase)

                Text(groupsViewModel.activeGroup?.leaderboardPrize ?? "Winner picks next week's challenge")
                    .font(.headline.weight(.black))
                    .foregroundStyle(AppColours.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .stampCard(background: AppColours.cream, shadowOffset: 3)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(AppColours.ink)

            Text("Only you here")
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(AppColours.ink)

            Text("Add friends to this group to start ranking points.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColours.muted)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .stampCard(background: AppColours.cream, shadowOffset: 4)
    }
}
