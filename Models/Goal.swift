import Foundation

struct Goal: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let target: String
}
