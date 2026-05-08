import Foundation

struct Comment: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let userName: String
    let text: String
    let createdAt: Date
}
