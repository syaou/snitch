import Foundation

enum Vote: String, Codable {
    case approve
    case snitch
}

struct ProofVote: Identifiable, Codable {
    var id: UUID = UUID()
    let voterId: UUID
    let vote: Vote
    let timestamp: Date
}
