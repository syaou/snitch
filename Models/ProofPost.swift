import Foundation

// a single proof post submitted to the feed for the group to vote on
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

    // works out approved or rejected once enough of the group has voted
    func status(votersCount: Int) -> ProofStatus {
        guard votersCount > 0 else { return .pending }
        let majority = votersCount / 2 + 1
        let snitchCount  = votes.filter { $0.vote == .snitch  }.count
        let approveCount = votes.filter { $0.vote == .approve }.count
        if snitchCount  >= majority { return .rejected }
        if approveCount >= majority { return .approved }
        return .pending
    }

    // human friendly stamp like "3h ago" used in the card header
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

extension ProofPost {
    // matches the Goal validation pattern
    static let notesMaxLength = 280

    enum ValidationError: String, Error {
        case notesTooLong = "Notes must be 280 characters or fewer"
    }

    // notes are optional so empty is fine, only the length is checked
    static func validateNotes(_ notes: String) -> ValidationError? {
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count > notesMaxLength { return .notesTooLong }
        return nil
    }

    // returns a new post with the vote added
    // if the voter has already voted, the same post comes back unchanged
    // calling this twice in a row is safe and gives the same result
    func addingVote(_ vote: ProofVote) -> ProofPost {
        guard !votes.contains(where: { $0.voterId == vote.voterId }) else {
            return self
        }
        var copy = self
        copy.votes.append(vote)
        return copy
    }
}
