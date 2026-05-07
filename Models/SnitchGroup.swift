import Foundation

struct SnitchGroup: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    var memberIds: [UUID]
    var goalIds: [UUID] = []
    var proofIds: [UUID] = []
}
