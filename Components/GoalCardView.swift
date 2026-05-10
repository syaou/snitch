import SwiftUI

struct GoalCardView: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 34, height: 34)

                    Image(systemName: "target")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 15, weight: .semibold))

                    Text(goal.description)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    Text(goal.scheduleText)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.blue)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(progressPeriodText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(progressShortText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.16))
                            .frame(height: 5)

                        Capsule()
                            .fill(Color.black)
                            .frame(width: geometry.size.width * progressValue, height: 5)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }

    private var progressShortText: String {
        switch goal.title {
        case "Go to gym 3x a week": return "2 / 3"
        case "Study 2 hours daily": return "5 / 7"
        case "Walk 10k steps": return "4 / 7"
        default: return "0 / \(goal.targetCount)"
        }
    }

    private var progressPeriodText: String {
        switch goal.frequency {
        case .daily:
            return "Today"
        case .weekly:
            return "This Week"
        case .monthly:
            return "This Month"
        }
    }

    private var progressValue: CGFloat {
        switch goal.title {
        case "Go to gym 3x a week": return 0.67
        case "Study 2 hours daily": return 0.71
        case "Walk 10k steps": return 0.57
        default: return 1
        }
    }
}
