import Foundation

enum Vote: String, Codable {
    case approve
    case snitch
}

struct ProofVote: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let voterId: UUID
    let vote: Vote
    let timestamp: Date
}
