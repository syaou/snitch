import SwiftUI

struct SnitchProofView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel
    @Environment(\.dismiss) private var dismiss

    let post: ProofPost

    @State private var selectedReason = "Effort doesn't match the claim"
    @State private var note = ""

    private let reasons = [
        ("Reused photo", "Looks taken another day, recycled, or duplicated"),
        ("Wrong activity shown", "Photo doesn't match the claimed goal"),
        ("Effort doesn't match the claim", "e.g. barely counts as a 5K run"),
        ("Other", "Explain below")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                reasonsSection
                noteSection
                warningSection
                submitButton
                footerNote
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColours.mustard)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var reasonsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("What looks wrong?", icon: "magnifyingglass")

            VStack(spacing: 10) {
                ForEach(Array(reasons.enumerated()), id: \.element.0) { index, reason in
                    FlagReasonRow(
                        title: reason.0,
                        subtitle: reason.1,
                        isSelected: selectedReason == reason.0,
                        iconName: reasonIcon(for: index)
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            selectedReason = reason.0
                        }
                    }
                }
            }
        }
    }

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Add a note", icon: "text.bubble.fill")

            TextField("Give more context to help the group decide...", text: $note, axis: .vertical)
                .lineLimit(4, reservesSpace: true)
                .padding(16)
                .stampCard(background: AppColours.cream, shadowOffset: 2)
        }
    }

    private var warningSection: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "shield.lefthalf.filled")
                .font(.headline.weight(.black))
                .foregroundStyle(AppColours.ink)
                .frame(width: 34, height: 34)
                .background(AppColours.mustard)
                .overlay(Circle().stroke(AppColours.ink, lineWidth: 1.2))
                .clipShape(Circle())

            Text("Only snitch when the proof looks wrong.")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppColours.ink)
        }
        .padding(16)
        .stampCard(background: AppColours.cream, shadowOffset: 3)
    }

    private var submitButton: some View {
        AppButton(kind: .snitch) {
            // feed view model returns the score changes
            // users view model is what actually applies them
            let changes = feedViewModel.castVote(.snitch, by: SampleData.profile.id, on: post.id, groups: groupsViewModel)
            usersViewModel.apply(changes)
            dismiss()
        } label: {
            Label("Submit Snitch", systemImage: "flag.fill")
        }
    }

    private var footerNote: some View {
        Label("Group vote decides · 2 of 3 voters must agree", systemImage: "person.2.fill")
            .font(.footnote.weight(.bold))
            .foregroundStyle(AppColours.muted)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 12)
    }

    private func sectionLabel(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.black))
            .foregroundStyle(AppColours.ink)
            .textCase(.uppercase)
    }

    private func reasonIcon(for index: Int) -> String {
        switch index {
        case 0:
            return "photo.on.rectangle.angled"
        case 1:
            return "figure.walk"
        case 2:
            return "bolt.slash.fill"
        default:
            return "ellipsis.bubble.fill"
        }
    }
}

private struct FlagReasonRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let iconName: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName)
                .font(.headline.weight(.black))
                .foregroundStyle(isSelected ? AppColours.mustard : AppColours.ink)
                .frame(width: 38, height: 38)
                .background(isSelected ? AppColours.ink : AppColours.mustard.opacity(0.75))
                .overlay(Circle().stroke(AppColours.ink, lineWidth: 1.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.black))
                    .foregroundStyle(AppColours.ink)

                Text(subtitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppColours.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.headline.weight(.black))
                .foregroundStyle(isSelected ? AppColours.ink : AppColours.line)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .stampCard(background: isSelected ? AppColours.acid.opacity(0.85) : AppColours.cream, shadowOffset: isSelected ? 4 : 2)
    }
}
