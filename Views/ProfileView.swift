import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var feedViewModel: FeedViewModel

    private var profile: UserProfile {
        usersViewModel.user(id: SampleData.profile.id) ?? SampleData.profile
    }

    private var approvedCount: Int {
        feedViewModel.posts.filter {
            $0.userId == profile.id &&
            $0.status(votersCount: SampleData.votersCount) == .approved
        }.count
    }

    private var snitchedOnMeCount: Int {
        feedViewModel.posts.filter {
            $0.userId == profile.id &&
            $0.status(votersCount: SampleData.votersCount) == .rejected
        }.count
    }

    private var wrongSnitchCount: Int {
        feedViewModel.posts.filter { post in
            post.status(votersCount: SampleData.votersCount) == .approved &&
            post.votes.contains { $0.voterId == profile.id && $0.vote == .snitch }
        }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(Color.accentColor)

                    VStack(spacing: 4) {
                        Text(profile.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(profile.bio)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    statCards

                    breakdownRow
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }

    private var statCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCardView(title: "Goals", value: "\(profile.goalCount)")
            StatCardView(title: "Points", value: "\(profile.points)")
            StatCardView(title: "Streak", value: "\(profile.streak)")
            StatCardView(title: "Trust", value: "\(profile.trust)")
        }
    }

    private var breakdownRow: some View {
        HStack(spacing: 16) {
            breakdownItem(label: "Approved", value: approvedCount, tint: .green)
            divider
            breakdownItem(label: "Snitched", value: snitchedOnMeCount, tint: .red)
            divider
            breakdownItem(label: "Wrong calls", value: wrongSnitchCount, tint: .orange)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .background(AppColours.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func breakdownItem(label: String, value: Int, tint: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
                .foregroundStyle(tint)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.08))
            .frame(width: 1, height: 28)
    }
}
