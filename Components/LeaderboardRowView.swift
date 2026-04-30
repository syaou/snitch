import SwiftUI

struct LeaderboardRowView: View {
    let user: LeaderboardUser
    let rank: Int

    var body: some View {
        HStack(spacing: 12) {
            Text("#\(rank)")
                .font(.headline)
                .frame(width: 40, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)

                Text(user.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(user.points)")
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding()
        .background(AppColours.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
