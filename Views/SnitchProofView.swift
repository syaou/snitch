import SwiftUI

struct SnitchProofView: View {
    let post: ProofPost

    @State private var selectedReason = "Effort doesn't match the claim"
    @State private var note = ""

    private let reasons = [
        ("Photo looks old or recycled", "Photo may have been taken on a different day"),
        ("Wrong activity shown", "Photo doesn't match the claimed goal"),
        ("Effort doesn't match the claim", "e.g. barely counts as a 5K run"),
        ("I've seen this photo before", "Possible duplicate submission"),
        ("Other", "Explain below")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                headerCard
                reasonsSection
                noteSection
                warningSection
                submitButton
                footerNote
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Snitch on this")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "flag")
                .font(.title3)
                .foregroundStyle(Color.orange.opacity(0.95))

            VStack(alignment: .leading, spacing: 4) {
                Text("Snitching on \(post.userName)'s proof")
                    .font(.headline)

                Text("\(post.goalTitle) · submitted \(post.timeAgo)")
                    .font(.subheadline)
                    .foregroundStyle(Color.orange.opacity(0.95))
            }

            Spacer()
        }
        .padding(18)
        .background(Color.orange.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var reasonsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WHAT LOOKS WRONG?")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                ForEach(reasons, id: \.0) { reason in
                    FlagReasonRow(
                        title: reason.0,
                        subtitle: reason.1,
                        isSelected: selectedReason == reason.0
                    )
                    .onTapGesture {
                        selectedReason = reason.0
                    }
                }
            }
        }
    }

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ADD A NOTE (OPTIONAL)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            TextField("Give more context to help the group decide...", text: $note, axis: .vertical)
                .lineLimit(4, reservesSpace: true)
                .padding(16)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                }
        }
    }

    private var warningSection: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.circle")
                .foregroundStyle(.red)

            Text("False snitches lose you credibility. Only snitch if you genuinely believe this proof is invalid.")
                .font(.subheadline)
                .foregroundStyle(.red.opacity(0.95))
        }
        .padding(16)
        .background(Color.red.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var submitButton: some View {
        Button {
        } label: {
            Text("Submit snitch")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    private var footerNote: some View {
        Text("Group vote decides · 2 of 3 voters must agree")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 12)
    }
}

private struct FlagReasonRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(isSelected ? .blue : .primary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(isSelected ? .blue : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(isSelected ? Color.blue.opacity(0.12) : Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? Color.blue : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
        }
    }
}
