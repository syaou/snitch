import Foundation

struct UserProfile: Identifiable {
    let id = UUID()
    let name: String
    let bio: String
    let goalCount: Int
    let points: Int
}
