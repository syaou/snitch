import Foundation
import Combine

@MainActor
final class GoalsViewModel: ObservableObject {
    @Published private(set) var goals: [Goal] {
        didSet {
            Persistence.save(goals, forKey: PersistenceKeys.goals)
        }
    }

    init() {
        if let saved = Persistence.load([Goal].self, forKey: PersistenceKeys.goals) {
            self.goals = saved
        } else {
            self.goals = SampleData.goals
        }
    }

    func add(_ goal: Goal) {
        goals.append(goal)
    }

    func delete(id: UUID) {
        goals.removeAll { $0.id == id }
    }

    func update(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index] = goal
    }
}
