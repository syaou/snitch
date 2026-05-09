import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var navigateToInvite = false

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("e.g. Gym Squad", text: $name)
                } header: {
                    Text("Group name")
                } footer: {
                    Text("You can share an invite link after the group is created.")
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .disabled(trimmedName.isEmpty)
                }
            }
            .navigationDestination(isPresented: $navigateToInvite) {
                FriendInviteView(onDone: { dismiss() })
            }
        }
    }

    private func create() {
        guard !trimmedName.isEmpty else { return }
        let group = SnitchGroup(
            name: trimmedName,
            memberIds: [SampleData.profile.id]
        )
        groupsViewModel.add(group)
        groupsViewModel.setActive(group.id)
        navigateToInvite = true
    }
}
