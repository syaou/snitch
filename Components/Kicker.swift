import SwiftUI

struct Kicker: View {
    let text: String
    var color: Color = AppColours.muted

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .semibold, design: .monospaced))
            .tracking(1.4)
            .foregroundStyle(color)
    }
}
