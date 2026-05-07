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

    func castVote(_ vote: Vote, by voterId: UUID, on postId: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        var post = posts[index]
        guard !post.votes.contains(where: { $0.voterId == voterId }) else { return }
        post.votes.append(ProofVote(voterId: voterId, vote: vote, timestamp: Date()))
        posts[index] = post
    }
}
