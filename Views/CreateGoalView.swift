import SwiftUI

struct CreateGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GoalsViewModel

    @State private var title = ""
    @State private var description = ""
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
            }
            .navigationTitle("Set a Goal")
            .navigationBarTitleDisplayMode(.inline)
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
    }

    private func save() {
        titleError = Goal.validateTitle(title)
        descriptionError = Goal.validateDescription(description)
        guard isValid else { return }

        let goal = Goal(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            status: .inProgress,
            groupId: SampleData.defaultGroup.id,
            createdAt: Date()
        )
        viewModel.add(goal)
        dismiss()
    }
}
