import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255
        )
    }
}

enum AppColours {
    static let mustard = Color(hex: 0xFFD166)
    static let cream = Color(hex: 0xFFF5D4)
    static let paper = Color(hex: 0xFFFFFF)
    static let orange = Color(hex: 0xFF7A4D)
    static let acid = Color(hex: 0xFFB347)
    static let ink = Color(hex: 0x1F1408)
    static let muted = Color(hex: 0x5B5346)
    static let ringIdle = Color(hex: 0xE5DCC2)
    static let approved = orange
    static let snitched = Color(hex: 0xA51B18)
    static let danger = Color(hex: 0xA51B18)
    static let hairline = ink.opacity(0.16)
    static let border = ink.opacity(0.22)
    static let divider = ink.opacity(0.12)

    static let canvas = mustard
    static let cardBackground = cream
    static let mutedInk = muted
    static let yellow = mustard
    static let paleYellow = cream
    static let line = divider
    static let success = orange
    static let warning = orange

    static let accentPalette: [Color] = [
        mustard,
        orange,
        cream,
        cream
    ]

    static func accent(for index: Int) -> Color {
        accentPalette[index % accentPalette.count]
    }
}
