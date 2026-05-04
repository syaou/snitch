import Foundation

struct LeaderboardUser: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let points: Int
    let subtitle: String
}
