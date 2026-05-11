import SwiftUI

struct FeedView: View {
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var showingGroupSwitcher = false
    @State private var showingInvite = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    brandRow
                    titleRow

                    CardStackView()
                        .frame(minHeight: 420)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(AppColours.mustard)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingGroupSwitcher) {
                GroupSwitcherSheet()
            }
            .sheet(isPresented: $showingInvite) {
                NavigationStack {
                    FriendInviteView(onDone: { showingInvite = false })
                }
            }
        }
    }

    private var brandRow: some View {
        HStack(alignment: .center) {
            SnitchWordmark(size: 38, ink: AppColours.ink, eyeColor: AppColours.mustard)

            Spacer()

            Button {
                showingInvite = true
            } label: {
                Image(systemName: "person.2.badge.plus.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColours.ink)
                    .frame(width: 38, height: 38)
                    .background(AppColours.cream)
                    .overlay(Circle().stroke(AppColours.ink, lineWidth: 1.5))
                    .clipShape(Circle())
                    .shadow(color: AppColours.ink, radius: 0, x: 2, y: 2)
            }
            .buttonStyle(.plain)
        }
    }

    private var titleRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                showingGroupSwitcher = true
            } label: {
                HStack(spacing: 8) {
                    Text((groupsViewModel.activeGroup?.name ?? "Feed").uppercased())
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(AppColours.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(AppColours.orange)

                    Spacer()
                }
            }
            .buttonStyle(.plain)

            Kicker(text: groupKicker)
        }
    }

    private var groupKicker: String {
        let count = groupsViewModel.activeGroup?.memberIds.count ?? 0
        return "\(count) friend\(count == 1 ? "" : "s")"
    }
}
