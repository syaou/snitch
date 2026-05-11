import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel

    private var profile: UserProfile {
        usersViewModel.user(id: SampleData.profile.id) ?? SampleData.profile
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    statCards
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 90)
            }
            .background(AppColours.mustard)
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        Text(profile.name)
            .font(.system(size: 34, weight: .black))
            .foregroundStyle(AppColours.ink)
            .lineLimit(1)
            .minimumScaleFactor(0.78)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statCards: some View {
        VStack(spacing: 12) {
            StatCardView(title: "Goals", value: "\(profile.goalCount)")
            StatCardView(title: "Points", value: "\(profile.points)")
            StatCardView(title: "Streak", value: "\(profile.streak)")
        }
    }
}
