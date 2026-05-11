import SwiftUI

struct GoalCardView: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColours.mustard)
                        .frame(width: 38, height: 38)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(AppColours.ink, lineWidth: 1.2)
                        )

                    Image(systemName: "target")
                        .font(.system(size: 15, weight: .black))
                        .foregroundStyle(AppColours.ink)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(AppColours.ink)

                    Text(goal.description)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColours.muted)

                    StampPill(tone: .neutral, label: goal.scheduleText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.black))
                    .foregroundStyle(AppColours.ink.opacity(0.45))
            }

            Divider()
                .background(AppColours.ink)

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.caption2)
                        .foregroundStyle(AppColours.ink)

                    Text(progressPeriodText)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColours.muted)

                    Spacer()

                    Text(progressShortText)
                        .font(.caption2)
                        .fontWeight(.black)
                        .foregroundStyle(AppColours.ink)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColours.ringIdle)
                            .frame(height: 7)

                        Capsule()
                            .fill(AppColours.ink)
                            .frame(width: geometry.size.width * progressValue, height: 7)
                    }
                }
                .frame(height: 7)
            }
        }
        .padding(16)
        .stampCard(background: AppColours.cream, shadowOffset: 3)
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
        default: return 0
        }
    }
}
