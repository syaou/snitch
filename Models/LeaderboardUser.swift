import Foundation

struct LeaderboardUser: Identifiable {
    let id = UUID()
    let name: String
    let points: Int
    let subtitle: String
}
