import SwiftUI

extension View {
    /// Applies the stamp-style card look: cream surface, 1.5pt ink border,
    /// hard ink drop shadow with no blur.
    func stampCard(
        background: Color = AppColours.cream,
        corner: CGFloat = 4,
        shadowOffset: CGFloat = 4
    ) -> some View {
        self
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .stroke(AppColours.ink, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: corner))
            .shadow(color: AppColours.ink, radius: 0, x: shadowOffset, y: shadowOffset)
    }
}
