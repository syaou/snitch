import Foundation
import Combine

// owns the list of proof posts and the scoring rules
@MainActor
final class FeedViewModel: ObservableObject {
    // scoring numbers in one place, easy to tweak without touching logic
    private enum ScoringRules {
        static let approvedProofPoints = 10
        static let rejectedProofPenalty = 5
        static let streakIncreaseOnApproval = 1
        static let streakResetOnRejection = 0

        // first snitcher to a wrong proof gets the most, drops off after that
        static func snitchReward(for index: Int) -> Int {
            switch index {
            case 0:
                return 5
            case 1:
                return 3
            default:
                return 1
            }
        }
    }

    @Published private(set) var posts: [ProofPost] {
        didSet {
            // silent fallback if save fails, posts stay in memory until next save
            try? Persistence.save(posts, forKey: PersistenceKeys.posts)
        }
    }

    init() {
        if let saved = Persistence.load([ProofPost].self, forKey: PersistenceKeys.posts) {
            self.posts = saved
        } else {
            self.posts = SampleData.posts
        }
    }

    // appends a new proof to the feed
    func add(_ post: ProofPost) {
        posts.append(post)
    }

    // removes a proof by id, no-op if not found
    func delete(id: UUID) {
        posts.removeAll { $0.id == id }
    }

    // replaces a proof with a new value, no-op if not found
    func update(_ post: ProofPost) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index] = post
    }

    // records the vote and returns any score changes the caller should apply
    // returns an empty list when the vote did not move the post out of pending
    // the feed view model never touches the users view model directly
    func castVote(_ vote: Vote, by voterId: UUID, on postId: UUID, groups: GroupsViewModel) -> [ScoreChange] {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return [] }
        let original = posts[index]
        let newVote = ProofVote(voterId: voterId, vote: vote, timestamp: Date())
        let updated = original.addingVote(newVote)

        // post comes back unchanged when the voter already had a vote
        guard updated.votes.count != original.votes.count else { return [] }

        let votersCount = groups.votersCount(for: updated)
        let before = original.status(votersCount: votersCount)
        let after = updated.status(votersCount: votersCount)
        posts[index] = updated

        guard before == .pending, after != .pending else { return [] }
        return scoreChanges(for: updated, status: after)
    }

    // pure function, builds the list of score changes for a settled post
    // does not touch any view model, easy to test and easy to swap rules
    private func scoreChanges(for post: ProofPost, status: ProofStatus) -> [ScoreChange] {
        switch status {
        case .approved:
            return [
                ScoreChange(
                    userId: post.userId,
                    pointsDelta: ScoringRules.approvedProofPoints,
                    streakChange: .increase(by: ScoringRules.streakIncreaseOnApproval)
                )
            ]
        case .rejected:
            var changes: [ScoreChange] = [
                ScoreChange(
                    userId: post.userId,
                    pointsDelta: -ScoringRules.rejectedProofPenalty,
                    streakChange: .reset
                )
            ]

            let snitchVotes = post.votes
                .filter { $0.vote == .snitch }
                .sorted { $0.timestamp < $1.timestamp }

            for (index, vote) in snitchVotes.enumerated() {
                changes.append(
                    ScoreChange(
                        userId: vote.voterId,
                        pointsDelta: ScoringRules.snitchReward(for: index),
                        streakChange: .unchanged
                    )
                )
            }
            return changes
        case .pending:
            return []
        }
    }
}
