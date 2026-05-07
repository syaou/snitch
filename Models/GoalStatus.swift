import Foundation

enum GoalStatus: String, Codable, CaseIterable {
    case onTrack
    case missed
    case achieved
    case paused
    case inProgress

    var displayName: String {
        switch self {
        case .onTrack:    return "On track"
        case .missed:     return "Missed"
        case .achieved:   return "Achieved"
        case .paused:     return "Paused"
        case .inProgress: return "In progress"
        }
    }
}
