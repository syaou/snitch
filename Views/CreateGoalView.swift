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
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    sheetHeader(
                        title: "Set a Goal",
                        subtitle: "Make it clear enough for your group to verify."
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        fieldLabel("Title", icon: "pencil")
                        TextField("e.g. Go to gym 3x a week", text: $title)
                            .textFieldStyle(.plain)
                            .font(.headline)
                            .padding(14)
                            .stampCard(background: AppColours.cream, shadowOffset: 2)
                            .onChange(of: title) { _, newValue in
                                titleError = Goal.validateTitle(newValue)
                            }

                        if let error = titleError {
                            Text(error.rawValue)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppColours.warning)
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        fieldLabel("Description", icon: "text.alignleft")
                        TextField("Describe your goal...", text: $description, axis: .vertical)
                            .textFieldStyle(.plain)
                            .font(.subheadline)
                            .lineLimit(3, reservesSpace: true)
                            .padding(14)
                            .stampCard(background: AppColours.cream, shadowOffset: 2)
                            .onChange(of: description) { _, newValue in
                                descriptionError = Goal.validateDescription(newValue)
                            }

                        if let error = descriptionError {
                            Text(error.rawValue)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppColours.warning)
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        fieldLabel("Schedule", icon: "calendar")

                        Stepper(value: $targetCount, in: 1...99) {
                            scheduleRow(icon: "number", title: "Target", value: "\(targetCount)x")
                        }

                        Picker("Frequency", selection: $frequency) {
                            ForEach(GoalFrequency.allCases) { option in
                                Text(option.displayName).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)

                        Stepper(value: $durationDays, in: 1...365) {
                            scheduleRow(icon: "clock.fill", title: "Duration", value: "\(durationDays) days")
                        }
                    }
                    .padding(16)
                    .stampCard(background: AppColours.cream, shadowOffset: 3)

                    VStack(alignment: .leading, spacing: 14) {
                        fieldLabel("Group", icon: "person.2.fill")
                        Picker("Group", selection: $selectedGroupId) {
                            ForEach(groupsViewModel.groups) { group in
                                Text(group.name).tag(group.id as UUID?)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .stampCard(background: AppColours.cream, shadowOffset: 2)
                        .disabled(groupsViewModel.groups.isEmpty)

                        if groupsViewModel.groups.isEmpty {
                            Text("Create or join a group before setting a goal.")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppColours.warning)
                        }
                    }

                    AppButton(kind: .primary, disabled: !isValid) {
                        save()
                    } label: {
                        Label("Save Goal", systemImage: "checkmark.circle.fill")
                    }
                    .disabled(!isValid)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)
            }
            .background(AppColours.mustard)
            .navigationBarHidden(true)
            .onAppear {
                selectedGroupId = groupsViewModel.activeGroupId ?? groupsViewModel.groups.first?.id
            }
        }
    }

    private func sheetHeader(title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(AppColours.ink)

                Text(subtitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppColours.muted)
            }

            Spacer()

            closeButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline.weight(.black))
                .foregroundStyle(AppColours.ink)
                .frame(width: 38, height: 38)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.top, 2)
    }

    private func fieldLabel(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.black))
            .foregroundStyle(AppColours.ink)
    }

    private func scheduleRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppColours.ink)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.black))
                .foregroundStyle(AppColours.ink)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(AppColours.mustard)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppColours.ink, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))
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
