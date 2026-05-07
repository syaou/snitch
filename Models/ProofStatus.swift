import Foundation

enum ProofStatus: String, Codable {
    case pending
    case approved
    case rejected

    var displayName: String {
        switch self {
        case .pending:  return "Pending"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        }
    }
}
