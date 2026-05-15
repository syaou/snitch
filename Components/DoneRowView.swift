import SwiftUI

struct DoneRowView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    let post: ProofPost

    private var poster: UserProfile? {
        usersViewModel.user(id: post.userId)
    }

    private var status: ProofStatus {
        post.status(votersCount: groupsViewModel.votersCount(for: post))
    }

    private var voteSplit: String {
        let approve = post.votes.filter { $0.vote == .approve }.count
        let snitch = post.votes.filter { $0.vote == .snitch }.count
        return "\(approve)–\(snitch) · \(post.timeAgo)"
    }

    var body: some View {
        HStack(spacing: 10) {
            AvatarRingView(profile: poster, streak: poster?.streak ?? 0, size: 32, showStreakBadge: false)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(post.userName) · \(post.goalTitle)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AppColours.ink)
                    .lineLimit(1)

                Kicker(text: voteSplit)
            }

            Spacer()

            switch status {
            case .approved:
                StampPill(tone: .approved, label: "✓ vouched")
            case .rejected:
                StampPill(tone: .snitched, label: "✕ snitched")
            case .pending:
                EmptyView()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .stampCard(shadowOffset: 3)
    }
}
