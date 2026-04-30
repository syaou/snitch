import Combine

final class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = SampleData.goals
}
