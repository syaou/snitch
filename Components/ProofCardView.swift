import SwiftUI

struct ProofCardView: View {
    @State private var isLiked: Bool
    @State private var showComments = false
    @State private var newComment = ""

    let post: ProofPost

    init(post: ProofPost) {
        self.post = post
        _isLiked = State(initialValue: post.isLiked)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // TOP IMAGE
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .frame(height: 160)

                statusBadge
                    .padding(10)
            }

            // USER ROW
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text(initials)
                            .font(.caption)
                    }

                VStack(alignment: .leading) {
                    Text(post.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text(post.goalTitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(post.timeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // ACTION BUTTONS (Approve/Snitch)
            if post.status(votersCount: SampleData.votersCount) == .pending {
                HStack(spacing: 10) {
                    Text("Approve")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.15))
                        .clipShape(Capsule())

                    Text("Snitch")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.15))
                        .clipShape(Capsule())
                }
            } else {
                Text("Reviewed by you")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // LIKE + COMMENT
            HStack(spacing: 16) {
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(isLiked ? .red : .gray)
                }
                .buttonStyle(.plain)

                Button {
                    withAnimation {
                        showComments.toggle()
                    }
                } label: {
                    Image(systemName: "bubble.right")
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Open detail")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }

            // COMMENTS SECTION
            if showComments {
                VStack(alignment: .leading, spacing: 8) {

                    ForEach(post.comments) { comment in
                        Text("\(comment.userName): \(comment.text)")
                            .font(.caption)
                    }

                    HStack {
                        TextField("Add a comment...", text: $newComment)

                        Button("Send") {
                            newComment = ""
                        }
                        .font(.caption)
                    }
                }
                .padding(10)
                .background(Color.gray.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(AppColours.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }

    // MARK: - Helpers

    private var initials: String {
        let parts = post.userName.split(separator: " ")
        return parts.compactMap { $0.first }.prefix(2).map { String($0) }.joined()
    }

    private var currentStatus: ProofStatus {
        post.status(votersCount: SampleData.votersCount)
    }

    private var backgroundColor: Color {
        currentStatus == .approved
        ? Color.green.opacity(0.15)
        : Color.blue.opacity(0.15)
    }

    private var statusBadge: some View {
        Text(currentStatus == .approved ? "Approved" : "Pending review")
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.9))
            .clipShape(Capsule())
    }
}
