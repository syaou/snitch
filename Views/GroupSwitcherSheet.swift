import SwiftUI

struct GroupSwitcherSheet: View {
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingCreate = false
    @State private var groupToLeave: SnitchGroup?
    @State private var showLeaveAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    ForEach(groupsViewModel.groups) { group in
                        Button {
                            groupsViewModel.setActive(group.id)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: group.id == groupsViewModel.activeGroupId ? "checkmark.circle.fill" : "person.2.fill")
                                    .font(.title3.weight(.black))
                                    .foregroundStyle(AppColours.ink)
                                    .frame(width: 42, height: 42)
                                    .background(group.id == groupsViewModel.activeGroupId ? AppColours.acid : AppColours.cream)
                                    .overlay(Circle().stroke(AppColours.ink, lineWidth: 1.2))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(group.name)
                                        .font(.headline.weight(.black))
                                        .foregroundStyle(AppColours.ink)

                                    Text("\(group.memberIds.count) member\(group.memberIds.count == 1 ? "" : "s")")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(AppColours.muted)
                                }

                                Spacer()

                                if group.id == groupsViewModel.activeGroupId {
                                    Text("Active")
                                        .font(.caption2.weight(.black))
                                        .foregroundStyle(AppColours.mustard)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(AppColours.ink)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                            }
                            .padding(14)
                            .stampCard(background: AppColours.cream, shadowOffset: 3)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                groupToLeave = group
                                showLeaveAlert = true
                            } label: {
                                Label("Leave Group", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }

                AppButton(kind: .primary) {
                    showingCreate = true
                } label: {
                    Label("Create a Group", systemImage: "plus.circle.fill")
                }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)
            }
            .background(AppColours.mustard)
            .navigationBarHidden(true)
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

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Your Groups")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(AppColours.ink)

                Text("Switch the crew you are reviewing with.")
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
}
