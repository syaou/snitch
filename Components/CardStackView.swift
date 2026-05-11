import SwiftUI

struct CardStackView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    @State private var dragOffset: CGSize = .zero
    @State private var snitchTarget: ProofPost?

    private let voteThreshold: CGFloat = 110

    private var queue: [ProofPost] {
        viewModel.posts
            .filter { post in
                guard let activeId = groupsViewModel.activeGroupId else { return false }
                return post.groupId == activeId
            }
            .filter { $0.userId != SampleData.profile.id }
            .filter { $0.status(votersCount: SampleData.votersCount) == .pending }
            .filter { post in
                !post.votes.contains { $0.voterId == SampleData.profile.id }
            }
    }

    private var horizontalDominant: Bool {
        abs(dragOffset.width) >= abs(dragOffset.height)
    }

    var body: some View {
        VStack(spacing: 18) {
            stackArea
            swipeHint
        }
        .navigationDestination(item: $snitchTarget) { post in
            SnitchProofView(post: post)
        }
    }

    private var stackArea: some View {
        ZStack {
            if queue.isEmpty {
                emptyState
            } else {
                ForEach(Array(queue.prefix(2).enumerated()).reversed(), id: \.element.id) { index, post in
                    let isTop = index == 0

                    ProofCardSwipeView(post: post)
                        .scaleEffect(isTop ? 1 : 0.95)
                        .offset(y: isTop ? 0 : 8)
                        .offset(isTop ? dragOffset : .zero)
                        .rotationEffect(isTop && horizontalDominant ? .degrees(Double(dragOffset.width / 18)) : .zero)
                        .opacity(isTop ? 1 : 0.7)
                        .gesture(isTop ? dragGesture(for: post) : nil)
                        .overlay(alignment: .top) {
                            if isTop {
                                voteBadges
                                    .padding(.top, 24)
                            }
                        }
                        .zIndex(Double(queue.count - index))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var voteBadges: some View {
        ZStack {
            HStack {
                StampPill(tone: .approved, label: "approve")
                    .rotationEffect(.degrees(-8))
                    .opacity(horizontalDominant && dragOffset.width > 30 ? min(dragOffset.width / 100, 1) : 0)

                Spacer()

                StampPill(tone: .snitched, label: "snitch")
                    .rotationEffect(.degrees(8))
                    .opacity(horizontalDominant && dragOffset.width < -30 ? min(-dragOffset.width / 100, 1) : 0)
            }
            .padding(.horizontal, 20)
        }
    }

    private var swipeHint: some View {
        HStack(spacing: 10) {
            Label("snitch", systemImage: "arrow.left")
            Rectangle()
                .fill(AppColours.ink)
                .frame(width: 3, height: 3)
            Label("approve", systemImage: "arrow.right")
        }
        .font(.system(size: 12, weight: .black))
        .foregroundStyle(AppColours.ink)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .stampCard(background: AppColours.cream, shadowOffset: 2)
        .opacity(queue.isEmpty ? 0 : 0.9)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 42, weight: .black))
                .foregroundStyle(AppColours.ink)

            Text("All caught up")
                .font(.system(size: 28, weight: .black))
                .foregroundStyle(AppColours.ink)
                .multilineTextAlignment(.center)

            Text("No pending proofs to review.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColours.muted)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .stampCard(background: AppColours.cream, shadowOffset: 5)
    }

    private func dragGesture(for post: ProofPost) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let horizontalWins = abs(value.translation.width) >= abs(value.translation.height)

                if horizontalWins {
                    if value.translation.width > voteThreshold {
                        approveVote(on: post)
                    } else if value.translation.width < -voteThreshold {
                        triggerSnitch(on: post)
                    } else {
                        snapBack()
                    }
                } else {
                    snapBack()
                }
            }
    }

    private func snapBack() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            dragOffset = .zero
        }
    }

    private func approveVote(on post: ProofPost) {
        withAnimation(.easeOut(duration: 0.3)) {
            dragOffset = CGSize(width: 700, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewModel.castVote(.approve, by: SampleData.profile.id, on: post.id, users: usersViewModel)
            dragOffset = .zero
        }
    }

    private func triggerSnitch(on post: ProofPost) {
        withAnimation(.easeOut(duration: 0.3)) {
            dragOffset = CGSize(width: -700, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dragOffset = .zero
            snitchTarget = post
        }
    }
}
