import Combine

final class LeaderboardViewModel: ObservableObject {
    @Published var users: [LeaderboardUser] = SampleData.leaderboardUsers
}
