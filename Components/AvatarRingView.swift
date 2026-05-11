import SwiftUI

struct AvatarRingView: View {
    let profile: UserProfile?
    let streak: Int
    var brokenToday: Bool = false
    var size: CGFloat = 48
    var showStreakBadge: Bool = true

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarBody
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppColours.ink, lineWidth: 1.5))

            if showStreakBadge && streak > 0 {
                streakBadge
                    .offset(x: 4, y: 4)
            }
        }
    }

    private var initials: String {
        guard let profile else { return "?" }
        let parts = profile.name.split(separator: " ")
        return parts.compactMap { $0.first }.prefix(2).map(String.init).joined()
    }

    private var avatarBody: some View {
        ZStack {
            Circle().fill(brokenToday ? AppColours.danger.opacity(0.3) : AppColours.cream)
            Text(initials)
                .font(.system(size: size * 0.42, weight: .black, design: .default))
                .foregroundStyle(AppColours.ink)
        }
    }

    private var streakBadge: some View {
        HStack(spacing: 1) {
            Text("🔥")
                .font(.system(size: 8))
            Text("\(streak)")
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundStyle(AppColours.ink)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 1)
        .background(AppColours.orange)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(AppColours.ink, lineWidth: 1.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
