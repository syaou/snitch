import SwiftUI

struct AppButton<Label: View>: View {
    enum Kind {
        case primary
        case snitch
        case vouch
        case secondary
        case ghost
    }

    let kind: Kind
    var fullWidth: Bool = true
    var small: Bool = false
    var disabled: Bool = false
    var action: () -> Void
    @ViewBuilder var label: () -> Label

    private var bg: Color {
        if disabled { return AppColours.ink.opacity(0.08) }
        switch kind {
        case .primary:   return AppColours.orange
        case .snitch:    return AppColours.danger
        case .vouch:     return AppColours.acid
        case .secondary: return AppColours.cream
        case .ghost:     return Color.clear
        }
    }

    private var fg: Color {
        if disabled { return AppColours.muted }
        switch kind {
        case .snitch: return .white
        default:      return AppColours.ink
        }
    }

    private var stroke: Color {
        disabled ? AppColours.hairline : AppColours.ink
    }

    private var showShadow: Bool {
        !disabled && kind != .ghost
    }

    var body: some View {
        Button(action: action) {
            label()
                .font(.system(size: small ? 13 : 16, weight: .black, design: .default))
                .tracking(0.6)
                .foregroundStyle(fg)
                .padding(.horizontal, small ? 14 : 18)
                .padding(.vertical, small ? 9 : 14)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .background(bg)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(stroke, lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .shadow(color: showShadow ? AppColours.ink : .clear, radius: 0, x: 3, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}
