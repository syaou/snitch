import Foundation

enum SampleData {

    // MARK: - USERS

    static let sana  = UserProfile(name: "Sana Yousefi", bio: "Building better habits one step at a time.", goalCount: 5, points: 142, streak: 8)
    static let alex  = UserProfile(name: "Alex Johnson", bio: "Runner, lifter, snitch master.",             goalCount: 4, points: 128, streak: 6)
    static let sarah = UserProfile(name: "Sarah Chen",   bio: "Reading more, scrolling less.",              goalCount: 4, points: 113, streak: 5)
    static let mike  = UserProfile(name: "Mike Brown",   bio: "Chest day every day.",                       goalCount: 3, points: 91,  streak: 4)
    static let priya = UserProfile(name: "Priya Patel",  bio: "Meal prep, walks, and no skipped check-ins.", goalCount: 3, points: 84, streak: 3)
    static let omar  = UserProfile(name: "Omar Haddad",  bio: "Trying to make study blocks less painful.",  goalCount: 2, points: 76,  streak: 2)
    static let mia   = UserProfile(name: "Mia Roberts",  bio: "Pilates, hydration, and early nights.",      goalCount: 3, points: 69,  streak: 6)

    static let users: [UserProfile] = [sana, alex, sarah, mike, priya, omar, mia]
    static let profile = sana

    // MARK: - GROUP

    static let defaultGroup = SnitchGroup(
        name: "My Friends",
        memberIds: users.map { $0.id },
        leaderboardPrize: "Winner chooses the weekend hangout"
    )

    static let gymSquadGroup = SnitchGroup(
        name: "Gym Squad",
        memberIds: [alex.id, mike.id, mia.id],
        leaderboardPrize: "Losers buy the winner a protein smoothie"
    )

    static let studyCrewGroup = SnitchGroup(
        name: "Study Crew",
        memberIds: [sana.id, sarah.id, omar.id],
        leaderboardPrize: "Winner gets first pick of study playlist"
    )

    static let wellnessGroup = SnitchGroup(
        name: "Wellness",
        memberIds: [sana.id, priya.id, mia.id],
        leaderboardPrize: "Lowest score brings post-walk coffees"
    )

    static let groups: [SnitchGroup] = [
        defaultGroup,
        gymSquadGroup,
        studyCrewGroup,
        wellnessGroup
    ]

    /// Number of friends who could vote on a post (everyone except the poster).
    static var votersCount: Int { defaultGroup.memberIds.count - 1 }

    // MARK: - GOALS

    static let gymGoal = Goal(
        title: "Go to gym 3x a week",
        description: "Stay consistent with strength and cardio sessions this week.",
        status: .onTrack,
        groupId: defaultGroup.id,
        createdAt: Date(),
        targetCount: 3,
        frequency: .weekly,
        durationDays: 30
    )

    static let studyGoal = Goal(
        title: "Study 2 hours daily",
        description: "Keep a focused study routine and log your daily progress.",
        status: .onTrack,
        groupId: defaultGroup.id,
        createdAt: Date(),
        targetCount: 1,
        frequency: .daily,
        durationDays: 30
    )

    static let walkGoal = Goal(
        title: "Walk 10k steps",
        description: "Hit your step goal on most days and keep your streak alive.",
        status: .missed,
        groupId: defaultGroup.id,
        createdAt: Date(),
        targetCount: 1,
        frequency: .daily,
        durationDays: 14
    )

    static let readGoal = Goal(
        title: "Read 20 Pages · 30 min",
        description: "Daily reading habit.",
        status: .achieved,
        groupId: defaultGroup.id,
        createdAt: Date(),
        targetCount: 1,
        frequency: .daily,
        durationDays: 30
    )

    static let mealPrepGoal = Goal(
        title: "Meal prep 3 lunches",
        description: "Prep balanced lunches before the week gets chaotic.",
        status: .onTrack,
        groupId: defaultGroup.id,
        createdAt: Date().addingTimeInterval(-5 * 24 * 3600),
        targetCount: 3,
        frequency: .weekly,
        durationDays: 21
    )

    static let waterGoal = Goal(
        title: "Drink 2L water",
        description: "Track hydration every day and upload bottle proof.",
        status: .onTrack,
        groupId: wellnessGroup.id,
        createdAt: Date().addingTimeInterval(-4 * 24 * 3600),
        targetCount: 1,
        frequency: .daily,
        durationDays: 14
    )

    static let pilatesGoal = Goal(
        title: "Pilates twice a week",
        description: "Two focused sessions with a photo after class.",
        status: .onTrack,
        groupId: wellnessGroup.id,
        createdAt: Date().addingTimeInterval(-8 * 24 * 3600),
        targetCount: 2,
        frequency: .weekly,
        durationDays: 30
    )

    static let legDayGoal = Goal(
        title: "Leg day twice",
        description: "No skipping the painful sessions this week.",
        status: .onTrack,
        groupId: gymSquadGroup.id,
        createdAt: Date().addingTimeInterval(-6 * 24 * 3600),
        targetCount: 2,
        frequency: .weekly,
        durationDays: 30
    )

    static let proteinGoal = Goal(
        title: "Hit protein target",
        description: "Log a high-protein meal after training.",
        status: .onTrack,
        groupId: gymSquadGroup.id,
        createdAt: Date().addingTimeInterval(-3 * 24 * 3600),
        targetCount: 5,
        frequency: .weekly,
        durationDays: 30
    )

    static let focusGoal = Goal(
        title: "Two deep work blocks",
        description: "Two focused study sessions with phone away.",
        status: .onTrack,
        groupId: studyCrewGroup.id,
        createdAt: Date().addingTimeInterval(-2 * 24 * 3600),
        targetCount: 2,
        frequency: .daily,
        durationDays: 10
    )

    static let goals: [Goal] = [
        gymGoal,
        studyGoal,
        walkGoal,
        readGoal,
        mealPrepGoal,
        waterGoal,
        pilatesGoal,
        legDayGoal,
        proteinGoal,
        focusGoal
    ]

    // MARK: - POSTS

    static let posts: [ProofPost] = [
        ProofPost(
            userId: alex.id,    userName: alex.name,
            goalId: gymGoal.id, goalTitle: "Morning Run 5K",
            groupId: defaultGroup.id,
            iconName: "figure.run",
            createdAt: Date().addingTimeInterval(-2 * 3600),
            votes: [
                ProofVote(voterId: sarah.id, vote: .approve, timestamp: Date().addingTimeInterval(-90 * 60)),
                ProofVote(voterId: mike.id, vote: .approve, timestamp: Date().addingTimeInterval(-70 * 60))
            ],
            comments: [
                Comment(userName: "Sana", text: "Solid run", createdAt: Date().addingTimeInterval(-80 * 60)),
                Comment(userName: "Mike", text: "Keep pushing", createdAt: Date().addingTimeInterval(-65 * 60))
            ]
        ),

        ProofPost(
            userId: sarah.id,    userName: sarah.name,
            goalId: readGoal.id, goalTitle: "Read 20 Pages · 30 min",
            groupId: defaultGroup.id,
            iconName: "book.closed",
            createdAt: Date().addingTimeInterval(-5 * 3600),
            votes: [
                ProofVote(voterId: sana.id, vote: .approve, timestamp: Date().addingTimeInterval(-4 * 3600)),
                ProofVote(voterId: alex.id, vote: .approve, timestamp: Date().addingTimeInterval(-3 * 3600)),
                ProofVote(voterId: mike.id, vote: .approve, timestamp: Date().addingTimeInterval(-2 * 3600)),
                ProofVote(voterId: omar.id, vote: .approve, timestamp: Date().addingTimeInterval(-90 * 60))
            ],
            comments: [
                Comment(userName: "Alex", text: "Nice consistency", createdAt: Date().addingTimeInterval(-3 * 3600))
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
                Comment(userName: "Sana", text: "Heavy day", createdAt: Date().addingTimeInterval(-40 * 60)),
                Comment(userName: "Alex", text: "Respect", createdAt: Date().addingTimeInterval(-35 * 60))
            ]
        ),

        ProofPost(
            userId: sana.id, userName: sana.name,
            goalId: walkGoal.id, goalTitle: walkGoal.title,
            groupId: defaultGroup.id,
            iconName: "figure.walk",
            createdAt: Date().addingTimeInterval(-3 * 3600),
            notes: "Finished the last 2k after dinner.",
            votes: [
                ProofVote(voterId: sarah.id, vote: .approve, timestamp: Date().addingTimeInterval(-2 * 3600)),
                ProofVote(voterId: alex.id, vote: .approve, timestamp: Date().addingTimeInterval(-95 * 60))
            ],
            comments: [
                Comment(userName: "Priya", text: "Evening walks count", createdAt: Date().addingTimeInterval(-90 * 60))
            ],
            isLiked: true
        ),

        ProofPost(
            userId: sana.id, userName: sana.name,
            goalId: studyGoal.id, goalTitle: studyGoal.title,
            groupId: studyCrewGroup.id,
            iconName: "timer",
            createdAt: Date().addingTimeInterval(-26 * 3600),
            notes: "Two Pomodoro blocks before work.",
            votes: [
                ProofVote(voterId: sarah.id, vote: .approve, timestamp: Date().addingTimeInterval(-25 * 3600)),
                ProofVote(voterId: omar.id, vote: .approve, timestamp: Date().addingTimeInterval(-24 * 3600))
            ]
        ),

        ProofPost(
            userId: sana.id, userName: sana.name,
            goalId: waterGoal.id, goalTitle: waterGoal.title,
            groupId: wellnessGroup.id,
            iconName: "drop.fill",
            createdAt: Date().addingTimeInterval(-50 * 3600),
            notes: "Bottle refill number four.",
            votes: [
                ProofVote(voterId: priya.id, vote: .approve, timestamp: Date().addingTimeInterval(-49 * 3600)),
                ProofVote(voterId: mia.id, vote: .approve, timestamp: Date().addingTimeInterval(-48 * 3600))
            ]
        ),

        ProofPost(
            userId: priya.id, userName: priya.name,
            goalId: mealPrepGoal.id, goalTitle: mealPrepGoal.title,
            groupId: defaultGroup.id,
            iconName: "fork.knife",
            createdAt: Date().addingTimeInterval(-75 * 60),
            notes: "Three containers ready for uni days.",
            votes: [
                ProofVote(voterId: sarah.id, vote: .approve, timestamp: Date().addingTimeInterval(-45 * 60))
            ],
            comments: [
                Comment(userName: "Mia", text: "That looks organised", createdAt: Date().addingTimeInterval(-35 * 60))
            ]
        ),

        ProofPost(
            userId: omar.id, userName: omar.name,
            goalId: focusGoal.id, goalTitle: focusGoal.title,
            groupId: studyCrewGroup.id,
            iconName: "laptopcomputer",
            createdAt: Date().addingTimeInterval(-35 * 60),
            notes: "Library desk, phone on do not disturb.",
            votes: []
        ),

        ProofPost(
            userId: mia.id, userName: mia.name,
            goalId: pilatesGoal.id, goalTitle: pilatesGoal.title,
            groupId: wellnessGroup.id,
            iconName: "figure.mind.and.body",
            createdAt: Date().addingTimeInterval(-4 * 3600),
            votes: [
                ProofVote(voterId: priya.id, vote: .approve, timestamp: Date().addingTimeInterval(-3 * 3600))
            ],
            comments: [
                Comment(userName: "Sana", text: "This is making me book a class", createdAt: Date().addingTimeInterval(-2 * 3600))
            ]
        ),

        ProofPost(
            userId: mike.id, userName: mike.name,
            goalId: proteinGoal.id, goalTitle: proteinGoal.title,
            groupId: gymSquadGroup.id,
            iconName: "takeoutbag.and.cup.and.straw",
            createdAt: Date().addingTimeInterval(-30 * 3600),
            notes: "Claimed 45g protein. Looks like dessert.",
            votes: [
                ProofVote(voterId: alex.id, vote: .snitch, timestamp: Date().addingTimeInterval(-29 * 3600)),
                ProofVote(voterId: mia.id, vote: .snitch, timestamp: Date().addingTimeInterval(-28 * 3600))
            ],
            comments: [
                Comment(userName: "Alex", text: "I need the macros on this one", createdAt: Date().addingTimeInterval(-29 * 3600))
            ]
        ),

        ProofPost(
            userId: alex.id, userName: alex.name,
            goalId: gymGoal.id, goalTitle: "Post-run stretch",
            groupId: defaultGroup.id,
            iconName: "figure.cooldown",
            createdAt: Date().addingTimeInterval(-2 * 24 * 3600),
            votes: [
                ProofVote(voterId: sana.id, vote: .snitch, timestamp: Date().addingTimeInterval(-47 * 3600)),
                ProofVote(voterId: sarah.id, vote: .snitch, timestamp: Date().addingTimeInterval(-46 * 3600)),
                ProofVote(voterId: mike.id, vote: .snitch, timestamp: Date().addingTimeInterval(-45 * 3600)),
                ProofVote(voterId: priya.id, vote: .snitch, timestamp: Date().addingTimeInterval(-44 * 3600))
            ],
            comments: [
                Comment(userName: "Sarah", text: "This was definitely yesterday's photo", createdAt: Date().addingTimeInterval(-45 * 3600))
            ]
        ),

        ProofPost(
            userId: sarah.id, userName: sarah.name,
            goalId: studyGoal.id, goalTitle: "No-phone study block",
            groupId: defaultGroup.id,
            iconName: "iphone.slash",
            createdAt: Date().addingTimeInterval(-18 * 3600),
            notes: "Phone was away for the full session.",
            votes: [
                ProofVote(voterId: alex.id, vote: .approve, timestamp: Date().addingTimeInterval(-17 * 3600)),
                ProofVote(voterId: mike.id, vote: .approve, timestamp: Date().addingTimeInterval(-16 * 3600)),
                ProofVote(voterId: priya.id, vote: .approve, timestamp: Date().addingTimeInterval(-15 * 3600))
            ]
        )
    ]

}
