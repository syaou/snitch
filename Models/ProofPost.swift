import Foundation

struct ProofPost: Identifiable {
    let id = UUID()
    let userName: String
    let goalTitle: String
    let imageName: String
    let status: String
    let time: String

    var comments: [Comment] = []
    var isLiked: Bool = false
}
