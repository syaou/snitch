import SwiftUI

struct SnitchWordmark: View {
    var size: CGFloat = 22
    var ink: Color = AppColours.ink
    var eyeColor: Color = AppColours.cream

    var body: some View {
        HStack(spacing: 0) {
            snText
            eyes
            tchText
        }
        .tracking(size * 0.02)
    }

    private var snText: some View {
        Text("SN")
            .font(.system(size: size, weight: .black, design: .default))
            .foregroundStyle(ink)
    }

    private var tchText: some View {
        Text("TCH")
            .font(.system(size: size, weight: .black, design: .default))
            .foregroundStyle(ink)
    }

    private var eyes: some View {
        PeekEyesView(
            width: size * 0.32,
            height: size * 0.78,
            shape: .rectangle,
            eyeColor: eyeColor,
            pupilColor: ink,
            strokeColor: ink,
            strokeWidth: max(1.5, size * 0.07),
            look: .left
        )
        .padding(.horizontal, size * 0.06)
    }
}
