import SwiftUI

struct LeaderboardRowView: View {
    let user: LeaderboardUser
    let rank: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(rank == 1 ? AppColours.orange : AppColours.cream)
                    .frame(width: 42, height: 42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(AppColours.ink, lineWidth: 1.4)
                    )

                Text("#\(rank)")
                    .font(.headline.weight(.black))
                    .foregroundStyle(AppColours.ink)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline.weight(.black))
                    .foregroundStyle(AppColours.ink)

                Text(user.subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColours.muted)
            }

            Spacer()

            HStack(spacing: 5) {
                Image(systemName: "bolt.fill")
                    .font(.caption)
                Text("\(user.points)")
                    .font(.title3.weight(.black))
            }
            .foregroundStyle(AppColours.ink)
        }
        .padding()
        .stampCard(background: rank == 1 ? AppColours.acid.opacity(0.92) : AppColours.cream, shadowOffset: 3)
    }
}
