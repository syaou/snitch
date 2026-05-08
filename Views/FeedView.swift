import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    private let pendingFriendRequests = 2

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
        }
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("THURSDAY")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text("Feed")
                    .font(.system(size: 34, weight: .bold))
            }

            Spacer()

            HStack(spacing: 10) {
                NavigationLink {
                    FriendsView()
                } label: {
                    iconBadge(systemName: "person.2", badgeCount: pendingFriendRequests, tint: .green)
                }
                .buttonStyle(.plain)

                iconBadge(systemName: "bell", badgeCount: 0, tint: .blue)
            }
        }
    }

    private func iconBadge(systemName: String, badgeCount: Int, tint: Color) -> some View {
        Circle()
            .fill(tint.opacity(0.15))
            .frame(width: 46, height: 46)
            .overlay {
                Image(systemName: systemName)
                    .foregroundStyle(tint)
            }
            .overlay(alignment: .topTrailing) {
                if badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 18, height: 18)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 2, y: -2)
                }
            }
    }
}
