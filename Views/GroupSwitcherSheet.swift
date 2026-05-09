import SwiftUI

struct GroupSwitcherSheet: View {
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingCreate = false
    @State private var groupToLeave: SnitchGroup?
    @State private var showLeaveAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(groupsViewModel.groups) { group in
                        Button {
                            groupsViewModel.setActive(group.id)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(group.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)

                                    Text("\(group.memberIds.count) member\(group.memberIds.count == 1 ? "" : "s")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if group.id == groupsViewModel.activeGroupId {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                groupToLeave = group
                                showLeaveAlert = true
                            } label: {
                                Label("Leave", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)

                Button {
                    showingCreate = true
                } label: {
                    Label("Create a Group", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .navigationTitle("Your Groups")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingCreate) {
                CreateGroupView()
            }
            .alert("Leave \(groupToLeave?.name ?? "group")?", isPresented: $showLeaveAlert) {
                Button("Leave", role: .destructive) {
                    if let group = groupToLeave {
                        groupsViewModel.leave(group.id)
                    }
                    groupToLeave = nil
                }
                Button("Cancel", role: .cancel) {
                    groupToLeave = nil
                }
            } message: {
                Text("You'll need a new invite link to rejoin.")
            }
        }
    }
}
