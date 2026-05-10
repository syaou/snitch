import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    @Published private(set) var posts: [ProofPost] {
        didSet {
            Persistence.save(posts, forKey: PersistenceKeys.posts)
        }
    }

    init() {
        if let saved = Persistence.load([ProofPost].self, forKey: PersistenceKeys.posts) {
            self.posts = saved
        } else {
            self.posts = SampleData.posts
        }
    }

    func add(_ post: ProofPost) {
        posts.append(post)
    }

    func delete(id: UUID) {
        posts.removeAll { $0.id == id }
    }

    func update(_ post: ProofPost) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index] = post
    }

    func addComment(to postId: UUID, text: String, by userName: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        var post = posts[index]
        post.comments.append(Comment(userName: userName, text: trimmed, createdAt: Date()))
        posts[index] = post
    }

    func castVote(_ vote: Vote, by voterId: UUID, on postId: UUID, users: UsersViewModel) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        var post = posts[index]
        guard !post.votes.contains(where: { $0.voterId == voterId }) else { return }

        let votersCount = SampleData.votersCount
        let before = post.status(votersCount: votersCount)
        post.votes.append(ProofVote(voterId: voterId, vote: vote, timestamp: Date()))
        let after = post.status(votersCount: votersCount)
        posts[index] = post

        guard before == .pending, after != .pending else { return }
        applyOutcome(post: post, status: after, users: users)
    }

    private func applyOutcome(post: ProofPost, status: ProofStatus, users: UsersViewModel) {
        switch status {
        case .approved:
            users.update(post.userId) { profile in
                profile.points += 10
                profile.trust = min(100, profile.trust + 2)
                profile.streak += 1
            }
            for vote in post.votes where vote.vote == .snitch {
                users.update(vote.voterId) { profile in
                    profile.trust = max(0, profile.trust - 3)
                }
            }
        case .rejected:
            users.update(post.userId) { profile in
                profile.points = max(0, profile.points - 5)
                profile.trust = max(0, profile.trust - 5)
                profile.streak = 0
            }

            let snitchVotes = post.votes
                .filter { $0.vote == .snitch }
                .sorted { $0.timestamp < $1.timestamp }

            for (index, vote) in snitchVotes.enumerated() {
                users.update(vote.voterId) { profile in
                    profile.points += snitchReward(for: index)
                }
            }
        case .pending:
            break
        }
    }

    private func snitchReward(for index: Int) -> Int {
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
