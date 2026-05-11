import SwiftUI

struct ProofCardSwipeView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    let post: ProofPost

    private var poster: UserProfile? {
        usersViewModel.user(id: post.userId)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(AppColours.mustard)
                .overlay(
                    Rectangle()
                        .fill(AppColours.ink)
                        .frame(height: 1.2)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                )

            photoSection

            footer
                .padding(12)
                .background(AppColours.cream)
                .overlay(
                    Rectangle()
                        .fill(AppColours.ink)
                        .frame(height: 1.2)
                        .frame(maxHeight: .infinity, alignment: .top)
                )
        }
        .stampCard(background: AppColours.cream, shadowOffset: 4)
    }

    private var header: some View {
        HStack(spacing: 8) {
            AvatarRingView(profile: poster, streak: poster?.streak ?? 0, size: 28, showStreakBadge: false)

            Text(post.userName)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AppColours.ink)
                .lineLimit(1)

            Spacer()

            Kicker(text: post.timeAgo)
        }
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Goal - \(post.goalTitle)".uppercased())
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(AppColours.ink)
                .lineLimit(1)

            if let notes = post.notes, !notes.isEmpty {
                Text("\"\(notes)\"")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColours.ink)
                    .lineLimit(2)
            }
        }
    }

    private var photoSection: some View {
        Group {
            if let data = post.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    .clipped()
            } else {
                ZStack {
                    Rectangle()
                        .fill(AppColours.mustard.opacity(0.6))

                    Image(systemName: post.iconName)
                        .font(.system(size: 70))
                        .foregroundStyle(AppColours.ink.opacity(0.45))
                }
                .frame(height: 280)
            }
        }
    }
}
