import Foundation
import Combine

final class LeaderboardViewModel: ObservableObject {
    func ranked(from profiles: [UserProfile]) -> [LeaderboardUser] {
        profiles
            .sorted { $0.points > $1.points }
            .map {
                LeaderboardUser(
                    id: $0.id,
                    name: $0.name,
                    points: $0.points,
                    subtitle: "\($0.streak) day streak"
                )
            }
    }
}
