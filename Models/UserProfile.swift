import Foundation

struct UserProfile: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let bio: String
    var goalCount: Int
    var points: Int
    var trust: Int = 100
    var streak: Int = 0
}
