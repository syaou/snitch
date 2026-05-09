import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @State private var showingGroupSwitcher = false
    @State private var showingInvite = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground).ignoresSafeArea()

                CardStackView()
                    .padding(.horizontal, 18)
                    .padding(.top, 90)
                    .padding(.bottom, 90)

                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
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

    private var topBar: some View {
        HStack(alignment: .center) {
            Button {
                showingGroupSwitcher = true
            } label: {
                HStack(spacing: 6) {
                    Text(groupsViewModel.activeGroup?.name ?? "Feed")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Image(systemName: "chevron.down")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                showingInvite = true
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}
