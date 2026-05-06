import Foundation

struct Goal: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let title: String
    let description: String
    var status: GoalStatus
    let groupId: UUID?
    let createdAt: Date
}

extension Goal {
    static let titleMaxLength = 80
    static let descriptionMaxLength = 200

    enum ValidationError: String, Error {
        case titleEmpty         = "Title can't be empty"
        case titleTooLong       = "Title must be 80 characters or fewer"
        case descriptionEmpty   = "Description can't be empty"
        case descriptionTooLong = "Description must be 200 characters or fewer"
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
}
