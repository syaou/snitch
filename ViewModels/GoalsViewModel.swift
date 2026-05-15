import Foundation
import Combine

// owns the user's list of goals across every group
@MainActor
final class GoalsViewModel: ObservableObject {
    @Published private(set) var goals: [Goal] {
        didSet {
            // silent fallback if save fails, goals stay in memory until next save
            try? Persistence.save(goals, forKey: PersistenceKeys.goals)
        }
    }

    init() {
        if let saved = Persistence.load([Goal].self, forKey: PersistenceKeys.goals) {
            self.goals = saved
        } else {
            self.goals = SampleData.goals
        }
    }

    // adds a brand new goal to the list
    func add(_ goal: Goal) {
        goals.append(goal)
    }

    // removes a goal by id, no-op if not found
    func delete(id: UUID) {
        goals.removeAll { $0.id == id }
    }

    // replaces a goal with a new value, no-op if not found
    func update(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index] = goal
    }
}
