import Foundation
import Combine

@MainActor
final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [UserProfile] {
        didSet {
            Persistence.save(users, forKey: PersistenceKeys.users)
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
}
