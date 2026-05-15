import Foundation
import Combine

// owns the list of groups and remembers which one the user is viewing
@MainActor
final class GroupsViewModel: ObservableObject {
    // validation errors for group name input, surfaced in CreateGroupView
    enum ValidationError: String, Error {
        case nameEmpty = "Group name can't be empty"
        case nameTooLong = "Group name must be 40 characters or fewer"
        case duplicateName = "You already have a group with this name"
    }

    @Published private(set) var groups: [SnitchGroup] {
        didSet {
            // silent fallback if save fails, groups stay in memory until next save
            try? Persistence.save(groups, forKey: PersistenceKeys.groups)
        }
    }

    @Published private(set) var activeGroupId: UUID? {
        didSet {
            // silent fallback if save fails, the active group resets next launch
            try? Persistence.save(activeGroupId, forKey: PersistenceKeys.activeGroupId)
        }
    }

    // the group the user is currently looking at, nil if none picked yet
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

    // adds a brand new group to the list
    func add(_ group: SnitchGroup) {
        groups.append(group)
    }

    // checks the name is not empty, not too long, and not already taken
    func validateGroupName(_ name: String) -> ValidationError? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .nameEmpty }
        if trimmed.count > 40 { return .nameTooLong }
        if groups.contains(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            return .duplicateName
        }
        return nil
    }

    // switches the active group, ignored if the id isn't one of ours
    func setActive(_ id: UUID) {
        guard groups.contains(where: { $0.id == id }) else { return }
        activeGroupId = id
    }

    // friends in the post's group who could vote on it (everyone except the poster)
    func votersCount(for post: ProofPost) -> Int {
        guard let groupId = post.groupId,
              let group = groups.first(where: { $0.id == groupId }) else {
            return 0
        }

        return group.memberIds.filter { $0 != post.userId }.count
    }

    // drops a group and falls back to the next one as active
    func leave(_ id: UUID) {
        groups.removeAll { $0.id == id }
        if activeGroupId == id {
            activeGroupId = groups.first?.id
        }
    }
}
