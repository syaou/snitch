import Foundation

enum GoalFrequency: String, Codable, CaseIterable, Identifiable {
    case daily
    case weekly
    case monthly

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }

    var periodLabel: String {
        switch self {
        case .daily:
            return "day"
        case .weekly:
            return "week"
        case .monthly:
            return "month"
        }
    }
}

struct Goal: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let title: String
    let description: String
    var status: GoalStatus
    let groupId: UUID?
    let createdAt: Date
    let targetCount: Int
    let frequency: GoalFrequency
    let durationDays: Int

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        status: GoalStatus,
        groupId: UUID?,
        createdAt: Date,
        targetCount: Int = 1,
        frequency: GoalFrequency = .weekly,
        durationDays: Int = 30
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.groupId = groupId
        self.createdAt = createdAt
        self.targetCount = targetCount
        self.frequency = frequency
        self.durationDays = durationDays
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case status
        case groupId
        case createdAt
        case targetCount
        case frequency
        case durationDays
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        status = try container.decode(GoalStatus.self, forKey: .status)
        groupId = try container.decodeIfPresent(UUID.self, forKey: .groupId)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        targetCount = try container.decodeIfPresent(Int.self, forKey: .targetCount) ?? 1
        frequency = try container.decodeIfPresent(GoalFrequency.self, forKey: .frequency) ?? .weekly
        durationDays = try container.decodeIfPresent(Int.self, forKey: .durationDays) ?? 30
    }
}

extension Goal {
    static let titleMaxLength = 80
    static let descriptionMaxLength = 200

    enum ValidationError: String, Error {
        case titleEmpty         = "Title can't be empty"
        case titleTooLong       = "Title must be 80 characters or fewer"
        case descriptionEmpty   = "Description can't be empty"
        case descriptionTooLong = "Description must be 200 characters or fewer"
        case targetInvalid      = "Target must be between 1 and 99"
        case durationInvalid    = "Duration must be between 1 and 365 days"
    }

    static func validateTitle(_ title: String) -> ValidationError? {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty                { return .titleEmpty }
        if trimmed.count > titleMaxLength { return .titleTooLong }
        return nil
    }

    static func validateDescription(_ description: String) -> ValidationError? {
        let trimmed = description.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty                      { return .descriptionEmpty }
        if trimmed.count > descriptionMaxLength { return .descriptionTooLong }
        return nil
    }

    static func validateTarget(_ targetCount: Int) -> ValidationError? {
        (1...99).contains(targetCount) ? nil : .targetInvalid
    }

    static func validateDuration(_ durationDays: Int) -> ValidationError? {
        (1...365).contains(durationDays) ? nil : .durationInvalid
    }

    var scheduleText: String {
        "\(targetCount)x per \(frequency.periodLabel) for \(durationDays) days"
    }
}
