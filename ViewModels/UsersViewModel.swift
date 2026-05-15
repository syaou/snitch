import Foundation
import Combine

@MainActor
final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [UserProfile] {
        didSet {
            // silent fallback if save fails, users stay in memory until next save
            try? Persistence.save(users, forKey: PersistenceKeys.users)
        }
    }

    init() {
        if let saved = Persistence.load([UserProfile].self, forKey: PersistenceKeys.users) {
            self.users = saved
        } else {
            self.users = SampleData.users
        }
    }

    func user(id: UUID) -> UserProfile? {
        users.first { $0.id == id }
    }

    func update(_ id: UUID, _ change: (inout UserProfile) -> Void) {
        guard let index = users.firstIndex(where: { $0.id == id }) else { return }
        change(&users[index])
    }

    // applies a batch of score changes from the feed view model
    // points stay zero or positive, streaks follow the StreakChange case
    func apply(_ changes: [ScoreChange]) {
        for change in changes {
            update(change.userId) { profile in
                profile.points = max(0, profile.points + change.pointsDelta)
                switch change.streakChange {
                case .unchanged:
                    break
                case .increase(let by):
                    profile.streak += by
                case .reset:
                    profile.streak = 0
                }
            }
        }
    }
}
