import SwiftUI

struct CreateGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @ObservedObject var viewModel: GoalsViewModel

    @State private var title = ""
    @State private var description = ""
    @State private var selectedGroupId: UUID?
    @State private var targetCount = 3
    @State private var frequency: GoalFrequency = .weekly
    @State private var durationDays = 30
    @State private var titleError: Goal.ValidationError?
    @State private var descriptionError: Goal.ValidationError?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("e.g. Go to gym 3x a week", text: $title)
                        .onChange(of: title) { _, newValue in
                            titleError = Goal.validateTitle(newValue)
                        }
                } header: {
                    Text("Title")
                } footer: {
                    if let error = titleError {
                        Text(error.rawValue)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    TextField("Describe your goal...", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .onChange(of: description) { _, newValue in
                            descriptionError = Goal.validateDescription(newValue)
                        }
                } header: {
                    Text("Description")
                } footer: {
                    if let error = descriptionError {
                        Text(error.rawValue)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Stepper(
                        "Target: \(targetCount) time\(targetCount == 1 ? "" : "s")",
                        value: $targetCount,
                        in: 1...99
                    )

                    Picker("Frequency", selection: $frequency) {
                        ForEach(GoalFrequency.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }

                    Stepper(
                        "Duration: \(durationDays) days",
                        value: $durationDays,
                        in: 1...365
                    )
                } header: {
                    Text("Schedule")
                }

                Section {
                    Picker("Group", selection: $selectedGroupId) {
                        ForEach(groupsViewModel.groups) { group in
                            Text(group.name).tag(group.id as UUID?)
                        }
                    }
                    .disabled(groupsViewModel.groups.isEmpty)
                } header: {
                    Text("Group")
                } footer: {
                    if groupsViewModel.groups.isEmpty {
                        Text("Create or join a group before setting a goal.")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Set a Goal")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                selectedGroupId = groupsViewModel.activeGroupId ?? groupsViewModel.groups.first?.id
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        Goal.validateTitle(title) == nil
            && Goal.validateDescription(description) == nil
            && selectedGroupId != nil
    }

    private func save() {
        titleError = Goal.validateTitle(title)
        descriptionError = Goal.validateDescription(description)
        guard isValid, let selectedGroupId else { return }

        let goal = Goal(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            status: .inProgress,
            groupId: selectedGroupId,
            createdAt: Date(),
            targetCount: targetCount,
            frequency: frequency,
            durationDays: durationDays
        )
        viewModel.add(goal)
        dismiss()
    }
}
