import SwiftUI

struct StampPill: View {
    enum Tone {
        case pending
        case approved
        case snitched
        case neutral
        case accent
    }

    let tone: Tone
    let label: String

    private var bg: Color {
        switch tone {
        case .pending:  return AppColours.ink
        case .approved: return AppColours.acid
        case .snitched: return AppColours.danger
        case .neutral:  return AppColours.cream
        case .accent:   return AppColours.orange
        }
    }

    private var fg: Color {
        switch tone {
        case .pending:  return AppColours.mustard
        case .approved: return AppColours.ink
        case .snitched: return .white
        case .neutral:  return AppColours.ink
        case .accent:   return AppColours.ink
        }
    }

    var body: some View {
        Text(label.uppercased())
            .font(.system(size: 11, weight: .black, design: .default))
            .tracking(0.5)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(bg)
            .foregroundStyle(fg)
            .overlay(
                Rectangle()
                    .stroke(AppColours.ink, lineWidth: 1.4)
            )
            .clipShape(Rectangle())
    }
}
