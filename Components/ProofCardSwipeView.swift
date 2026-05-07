import SwiftUI

struct ProofCardSwipeView: View {
    let post: ProofPost

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            photoSection

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(post.userName)
                        .font(.title3.weight(.semibold))
                        .lineLimit(1)

                    Spacer()

                    Text(post.timeAgo)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.06))
                        .clipShape(Capsule())
                }

                Text(post.goalTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(14)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.10), radius: 16, y: 8)
    }

    private var photoSection: some View {
        Group {
            if let data = post.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .clipped()
            } else {
                Color.blue.opacity(0.10)
                    .frame(height: 320)
                    .overlay {
                        Image(systemName: post.iconName)
                            .font(.system(size: 70))
                            .foregroundStyle(.blue.opacity(0.6))
                    }
            }
        }
    }
}
