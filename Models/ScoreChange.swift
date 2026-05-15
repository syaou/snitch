import Foundation

// a single tweak to a user profile
// the feed view model returns a list of these after a vote settles
// the users view model is what actually applies them
// this lets the two view models stay separate, neither knows about the other
struct ScoreChange {
    let userId: UUID
    let pointsDelta: Int
    let streakChange: StreakChange
}

enum StreakChange {
    case unchanged
    case increase(by: Int)
    case reset
}
