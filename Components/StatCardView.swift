import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 10) {
            Text(value)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(AppColours.ink)

            Text(title)
                .font(.caption.weight(.black))
                .foregroundStyle(AppColours.muted)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .stampCard(background: title == "Points" ? AppColours.acid : AppColours.cream, shadowOffset: 3)
    }
}
