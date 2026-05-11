
import SwiftUI

struct MyUploadsView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel

    private var myUploads: [ProofPost] {
        feedViewModel.posts
            .filter { $0.userId == SampleData.profile.id }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        List {
            if myUploads.isEmpty {
                emptyState
                    .listRowSeparator(.hidden)
            } else {
                ForEach(myUploads) { post in
                    NavigationLink {
                        ProofDetailView(post: post)
                    } label: {
                        MyUploadRowView(post: post)
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("My Uploads")
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text("No uploads yet")
                .font(.headline)

            Text("Photos you submit as proof will show up here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

private struct MyUploadRowView: View {
    let post: ProofPost

    private var status: ProofStatus {
        post.status(votersCount: SampleData.votersCount)
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
                    .font(.headline)

                Text(post.timeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    statusBadge

                    Text("\(approveCount) approve · \(snitchCount) snitch")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let data = post.photoData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.12))
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: post.iconName)
                        .foregroundStyle(.blue)
                }
        }
    }

    private var statusBadge: some View {
        Text(status.displayName)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.12))
            .clipShape(Capsule())
    }

    private var statusColor: Color {
        switch status {
        case .pending:
            return .orange
        case .approved:
            return .green
        case .rejected:
            return .red
        }
    }
}
