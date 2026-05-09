import Foundation
import Combine

@MainActor
final class GroupsViewModel: ObservableObject {
    @Published private(set) var groups: [SnitchGroup] {
        didSet {
            Persistence.save(groups, forKey: PersistenceKeys.groups)
        }
    }

    @Published private(set) var activeGroupId: UUID? {
        didSet {
            Persistence.save(activeGroupId, forKey: PersistenceKeys.activeGroupId)
        }
    }

    var activeGroup: SnitchGroup? {
        guard let id = activeGroupId else { return nil }
        return groups.first { $0.id == id }
    }

    init() {
        if let saved = Persistence.load([SnitchGroup].self, forKey: PersistenceKeys.groups) {
            self.groups = saved
        } else {
            self.groups = SampleData.groups
        }

        self.activeGroupId = Persistence.load(UUID.self, forKey: PersistenceKeys.activeGroupId)
            ?? self.groups.first?.id
    }

    func add(_ group: SnitchGroup) {
        groups.append(group)
    }

    func setActive(_ id: UUID) {
        guard groups.contains(where: { $0.id == id }) else { return }
        activeGroupId = id
    }

    func leave(_ id: UUID) {
        groups.removeAll { $0.id == id }
        if activeGroupId == id {
            activeGroupId = groups.first?.id
        }
    }
}
