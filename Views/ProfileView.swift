import SwiftUI

struct ProfileView: View {
    private let profile = SampleData.profile

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(Color.accentColor)

                    VStack(spacing: 4) {
                        Text(profile.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(profile.bio)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    HStack(spacing: 12) {
                        StatCardView(title: "Goals", value: "\(profile.goalCount)")
                        StatCardView(title: "Points", value: "\(profile.points)")
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}
