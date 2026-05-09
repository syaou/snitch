import SwiftUI

struct CardStackView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var dragOffset: CGSize = .zero
    @State private var skippedIds: Set<UUID> = []
    @State private var snitchTarget: ProofPost?

    private let voteThreshold: CGFloat = 110
    private let skipThreshold: CGFloat = 110

    private var queue: [ProofPost] {
        viewModel.posts
            .filter { !skippedIds.contains($0.id) }
            .filter { post in
                guard let activeId = groupsViewModel.activeGroupId else { return false }
                return post.groupId == activeId
            }
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
                Text("APPROVE")
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.black.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.green, lineWidth: 2)
                    }
                    .rotationEffect(.degrees(-10))
                    .opacity(horizontalDominant && dragOffset.width > 30 ? min(dragOffset.width / 100, 1) : 0)

                Spacer()

                Text("SNITCH")
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.black.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.red, lineWidth: 2)
                    }
                    .rotationEffect(.degrees(10))
                    .opacity(horizontalDominant && dragOffset.width < -30 ? min(-dragOffset.width / 100, 1) : 0)
            }
            .padding(.horizontal, 20)

            Text("SKIP")
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.black.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 2)
                }
                .opacity(!horizontalDominant && dragOffset.height < -30 ? min(-dragOffset.height / 100, 1) : 0)
        }
    }

    private var swipeHint: some View {
        HStack(spacing: 8) {
            Text("←").bold()
            Text("snitch")
            Text("·")
            Text("approve")
            Text("→").bold()
            Text("·")
            Text("↑").bold()
            Text("skip")
        }
        .font(.caption.weight(.medium))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
        .opacity(queue.isEmpty ? 0 : 0.9)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Text("All caught up")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("No pending proofs to review.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if !skippedIds.isEmpty {
                Button {
                    withAnimation(.spring()) {
                        skippedIds.removeAll()
                    }
                } label: {
                    Text("Bring back skipped (\(skippedIds.count))")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
        }
        .padding(40)
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
                    if value.translation.height < -skipThreshold {
                        skip(post)
                    } else {
                        snapBack()
                    }
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
            viewModel.castVote(.approve, by: SampleData.profile.id, on: post.id)
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

    private func skip(_ post: ProofPost) {
        withAnimation(.easeOut(duration: 0.3)) {
            dragOffset = CGSize(width: 0, height: -800)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            skippedIds.insert(post.id)
            dragOffset = .zero
        }
    }
}
