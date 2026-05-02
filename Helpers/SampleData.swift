import Foundation

enum SampleData {

    // MARK: - FEED POSTS

    static let posts: [ProofPost] = [
        ProofPost(
            userName: "Alex Johnson",
            goalTitle: "Morning Run 5K",
            imageName: "figure.run",
            status: "Pending",
            time: "2h ago",
            comments: [
                Comment(userName: "Sana", text: "Solid run 🔥"),
                Comment(userName: "Mike", text: "Keep pushing 💪")
            ]
        ),

        ProofPost(
            userName: "Sarah Chen",
            goalTitle: "Read 20 Pages · 30 min",
            imageName: "book.closed",
            status: "Approved",
            time: "5h ago",
            comments: [
                Comment(userName: "Alex", text: "Nice consistency 👏")
            ],
            isLiked: true
        ),

        ProofPost(
            userName: "Mike Brown",
            goalTitle: "Gym Session · Chest Day",
            imageName: "dumbbell",
            status: "Pending",
            time: "1h ago",
            comments: [
                Comment(userName: "Sana", text: "Let’s gooo 🔥"),
                Comment(userName: "Alex", text: "Heavy day 💪")
            ]
        )
    ]


    // MARK: - GOALS

    static let goals: [Goal] = [
        Goal(
            title: "Go to gym 3x a week",
            description: "Stay consistent with strength and cardio sessions this week.",
            target: "On track"
        ),
        Goal(
            title: "Study 2 hours daily",
            description: "Keep a focused study routine and log your daily progress.",
            target: "On track"
        ),
        Goal(
            title: "Walk 10k steps",
            description: "Hit your step goal on most days and keep your streak alive.",
            target: "Missed"
        )
    ]


    // MARK: - LEADERBOARD

    static let leaderboardUsers: [LeaderboardUser] = [
        LeaderboardUser(name: "Sana", points: 120, subtitle: "7 day streak"),
        LeaderboardUser(name: "Alex", points: 95, subtitle: "5 proofs approved"),
        LeaderboardUser(name: "Sarah", points: 88, subtitle: "3 goals completed"),
        LeaderboardUser(name: "Mike", points: 72, subtitle: "4 day streak")
    ]


    // MARK: - PROFILE

    static let profile = UserProfile(
        name: "Sana Yousefi",
        bio: "Building better habits one step at a time.",
        goalCount: 4,
        points: 120
    )
}
