import Foundation

enum SampleData {

    // MARK: - USERS

    static let sana  = UserProfile(name: "Sana Yousefi", bio: "Building better habits one step at a time.", goalCount: 4, points: 120)
    static let alex  = UserProfile(name: "Alex Johnson", bio: "Runner, lifter, snitch master.",             goalCount: 3, points: 95,  trust: 92)
    static let sarah = UserProfile(name: "Sarah Chen",   bio: "Reading more, scrolling less.",              goalCount: 4, points: 88)
    static let mike  = UserProfile(name: "Mike Brown",   bio: "Chest day every day.",                       goalCount: 2, points: 72,  trust: 78)

    static let users: [UserProfile] = [sana, alex, sarah, mike]
    static let profile = sana

    // MARK: - GROUP

    static let defaultGroup = SnitchGroup(
        name: "My Friends",
        memberIds: users.map { $0.id }
    )

    /// Number of friends who could vote on a post (everyone except the poster).
    static var votersCount: Int { defaultGroup.memberIds.count - 1 }

    // MARK: - GOALS

    static let gymGoal   = Goal(title: "Go to gym 3x a week",       description: "Stay consistent with strength and cardio sessions this week.", status: .onTrack,  groupId: defaultGroup.id, createdAt: Date())
    static let studyGoal = Goal(title: "Study 2 hours daily",       description: "Keep a focused study routine and log your daily progress.",    status: .onTrack,  groupId: defaultGroup.id, createdAt: Date())
    static let walkGoal  = Goal(title: "Walk 10k steps",            description: "Hit your step goal on most days and keep your streak alive.",  status: .missed,   groupId: defaultGroup.id, createdAt: Date())
    static let readGoal  = Goal(title: "Read 20 Pages · 30 min",    description: "Daily reading habit.",                                         status: .achieved, groupId: defaultGroup.id, createdAt: Date())

    static let goals: [Goal] = [gymGoal, studyGoal, walkGoal]

    // MARK: - POSTS

    static let posts: [ProofPost] = [
        ProofPost(
            userId: alex.id,    userName: alex.name,
            goalId: gymGoal.id, goalTitle: "Morning Run 5K",
            groupId: defaultGroup.id,
            iconName: "figure.run",
            createdAt: Date().addingTimeInterval(-2 * 3600),
            votes: [
                ProofVote(voterId: sarah.id, vote: .approve, timestamp: Date())
            ],
            comments: [
                Comment(userName: "Sana", text: "Solid run 🔥", createdAt: Date()),
                Comment(userName: "Mike", text: "Keep pushing 💪", createdAt: Date())
            ]
        ),

        ProofPost(
            userId: sarah.id,    userName: sarah.name,
            goalId: readGoal.id, goalTitle: "Read 20 Pages · 30 min",
            groupId: defaultGroup.id,
            iconName: "book.closed",
            createdAt: Date().addingTimeInterval(-5 * 3600),
            votes: [
                ProofVote(voterId: sana.id, vote: .approve, timestamp: Date()),
                ProofVote(voterId: alex.id, vote: .approve, timestamp: Date())
            ],
            comments: [
                Comment(userName: "Alex", text: "Nice consistency 👏", createdAt: Date())
            ],
            isLiked: true
        ),

        ProofPost(
            userId: mike.id,    userName: mike.name,
            goalId: gymGoal.id, goalTitle: "Gym Session · Chest Day",
            groupId: defaultGroup.id,
            iconName: "dumbbell",
            createdAt: Date().addingTimeInterval(-1 * 3600),
            comments: [
                Comment(userName: "Sana", text: "Let's gooo 🔥", createdAt: Date()),
                Comment(userName: "Alex", text: "Heavy day 💪", createdAt: Date())
            ]
        )
    ]

    // MARK: - LEADERBOARD

    static let leaderboardUsers: [LeaderboardUser] = [
        LeaderboardUser(name: "Sana",  points: 120, subtitle: "7 day streak"),
        LeaderboardUser(name: "Alex",  points: 95,  subtitle: "5 proofs approved"),
        LeaderboardUser(name: "Sarah", points: 88,  subtitle: "3 goals completed"),
        LeaderboardUser(name: "Mike",  points: 72,  subtitle: "4 day streak")
    ]
}
