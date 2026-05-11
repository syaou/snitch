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
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: "person.3.fill")
                            .font(.title2.weight(.black))
                            .foregroundStyle(AppColours.ink)
                            .frame(width: 52, height: 52)
                            .background(AppColours.cream)
                            .overlay(Circle().stroke(AppColours.ink, lineWidth: 1.4))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 5) {
                            Text("New Group")
                                .font(.system(size: 30, weight: .black))
                                .foregroundStyle(AppColours.ink)

                            Text("Create a crew, then invite friends to join.")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppColours.muted)
                        }

                        Spacer()
                    }
                    .padding(18)
                    .stampCard(background: AppColours.orange.opacity(0.82), shadowOffset: 4)

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Group name", systemImage: "tag.fill")
                            .font(.caption.weight(.black))
                            .foregroundStyle(AppColours.ink)

                    TextField("e.g. Gym Squad", text: $name)
                            .textFieldStyle(.plain)
                            .font(.headline)
                            .padding(14)
                            .stampCard(background: AppColours.cream, shadowOffset: 2)

                        Text("You can share an invite link after the group is created.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppColours.muted)
                    }

                    AppButton(kind: .primary, disabled: trimmedName.isEmpty) {
                        create()
                    } label: {
                        Label("Create Group", systemImage: "plus.circle.fill")
                    }
                    .disabled(trimmedName.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .background(AppColours.mustard)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.weight(.black))
                            .foregroundStyle(AppColours.ink)
                    }
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
