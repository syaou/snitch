import Foundation

struct SnitchGroup: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    var memberIds: [UUID]
    var goalIds: [UUID] = []
    var proofIds: [UUID] = []
    var leaderboardPrize: String = "Winner picks next week's challenge"

    init(
        id: UUID = UUID(),
        name: String,
        memberIds: [UUID],
        goalIds: [UUID] = [],
        proofIds: [UUID] = [],
        leaderboardPrize: String = "Winner picks next week's challenge"
    ) {
        self.id = id
        self.name = name
        self.memberIds = memberIds
        self.goalIds = goalIds
        self.proofIds = proofIds
        self.leaderboardPrize = leaderboardPrize
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case memberIds
        case goalIds
        case proofIds
        case leaderboardPrize
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        memberIds = try container.decode([UUID].self, forKey: .memberIds)
        goalIds = try container.decodeIfPresent([UUID].self, forKey: .goalIds) ?? []
        proofIds = try container.decodeIfPresent([UUID].self, forKey: .proofIds) ?? []
        leaderboardPrize = try container.decodeIfPresent(String.self, forKey: .leaderboardPrize)
            ?? "Winner picks next week's challenge"
    }
}
