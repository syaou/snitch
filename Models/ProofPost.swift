import Foundation

struct ProofPost: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let userId: UUID
    let userName: String
    let goalId: UUID
    let goalTitle: String
    let groupId: UUID?
    let iconName: String
    let createdAt: Date
    var photoData: Data? = nil
    var notes: String? = nil
    var votes: [ProofVote] = []

    func status(votersCount: Int) -> ProofStatus {
        guard votersCount > 0 else { return .pending }
        let majority = votersCount / 2 + 1
        let snitchCount  = votes.filter { $0.vote == .snitch  }.count
        let approveCount = votes.filter { $0.vote == .approve }.count
        if snitchCount  >= majority { return .rejected }
        if approveCount >= majority { return .approved }
        return .pending
    }

    var timeAgo: String {
        let interval = Date().timeIntervalSince(createdAt)
        let minutes = Int(interval / 60)
        let hours   = minutes / 60
        let days    = hours / 24
        if days    > 0 { return "\(days)d ago" }
        if hours   > 0 { return "\(hours)h ago" }
        if minutes > 0 { return "\(minutes)m ago" }
        return "just now"
    }
}
