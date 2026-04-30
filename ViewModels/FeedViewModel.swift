import Combine

final class FeedViewModel: ObservableObject {
    @Published var posts: [ProofPost] = SampleData.posts
}
