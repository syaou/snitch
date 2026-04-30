import SwiftUI

struct GoalsView: View {
    @StateObject private var viewModel = GoalsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("My Goals")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.bottom, 8)

                    ForEach(viewModel.goals) { goal in
                        GoalCardView(goal: goal)
                    }

                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Goal")
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundStyle(Color.gray.opacity(0.35))
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 18)
                .padding(.top, 20)
                .padding(.bottom, 90)
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
