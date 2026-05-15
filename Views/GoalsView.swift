import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var viewModel: GoalsViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var showingCreateGoal = false

    private var visibleGoals: [Goal] {
        viewModel.goals.filter { $0.groupId == groupsViewModel.activeGroupId }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    header

                    if visibleGoals.isEmpty {
                        emptyState
                    } else {
                        ForEach(visibleGoals) { goal in
                            GoalCardView(goal: goal)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.delete(id: goal.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }

                    AppButton(kind: .primary) {
                        showingCreateGoal = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Goal")
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 90)
            }
            .background(AppColours.mustard)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingCreateGoal) {
                CreateGoalView(viewModel: viewModel)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text("My Goals")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(AppColours.ink)
            }

            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "target")
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(AppColours.ink)

            Text("No goals here yet")
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(AppColours.ink)

            Text("Add a goal for this group to start collecting proof.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColours.muted)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .stampCard(background: AppColours.cream, shadowOffset: 4)
    }
}
