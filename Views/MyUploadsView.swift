
import SwiftUI

struct MyUploadsView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel

    private var myUploads: [ProofPost] {
        feedViewModel.posts
            .filter { $0.userId == SampleData.profile.id }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Kicker(text: "profile")

                Text("My Uploads")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(AppColours.ink)

                if myUploads.isEmpty {
                    emptyState
                } else {
                    ForEach(myUploads) { post in
                        NavigationLink {
                            ProofDetailView(post: post)
                        } label: {
                            MyUploadRowView(post: post)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 90)
        }
        .background(AppColours.mustard)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 34, weight: .black))
                .foregroundStyle(AppColours.ink)

            Text("No uploads yet")
                .font(.headline.weight(.black))
                .foregroundStyle(AppColours.ink)

            Text("Photos you submit as proof will show up here.")
                .font(.subheadline)
                .foregroundStyle(AppColours.muted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .stampCard(background: AppColours.cream, shadowOffset: 4)
    }
}

private struct MyUploadRowView: View {
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    let post: ProofPost

    private var status: ProofStatus {
        post.status(votersCount: groupsViewModel.votersCount(for: post))
    }

    private var approveCount: Int {
        post.votes.filter { $0.vote == .approve }.count
    }

    private var snitchCount: Int {
        post.votes.filter { $0.vote == .snitch }.count
    }

    var body: some View {
        HStack(spacing: 12) {
            thumbnail

            VStack(alignment: .leading, spacing: 6) {
                Text(post.goalTitle)
                    .font(.headline.weight(.black))
                    .foregroundStyle(AppColours.ink)

                Text(post.timeAgo)
                    .font(.caption)
                    .foregroundStyle(AppColours.muted)

                HStack(spacing: 8) {
                    statusBadge

                    Text("\(approveCount) approve · \(snitchCount) snitch")
                        .font(.caption2)
                        .foregroundStyle(AppColours.muted)
                }
            }

            Spacer()
        }
        .padding(12)
        .stampCard(background: AppColours.cream, shadowOffset: 3)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let data = post.photoData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        } else {
            RoundedRectangle(cornerRadius: 4)
                .fill(AppColours.mustard.opacity(0.55))
                .frame(width: 72, height: 72)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppColours.ink, lineWidth: 1)
                )
                .overlay {
                    Image(systemName: post.iconName)
                        .foregroundStyle(AppColours.ink)
                }
        }
    }

    private var statusBadge: some View {
        StampPill(tone: statusTone, label: status.displayName)
    }

    private var statusTone: StampPill.Tone {
        switch status {
        case .pending:
            return .pending
        case .approved:
            return .approved
        case .rejected:
            return .snitched
        }
    }
}
