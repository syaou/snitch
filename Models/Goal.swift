import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String
    var status: GoalStatus
    let groupId: UUID?
    let createdAt: Date
}
