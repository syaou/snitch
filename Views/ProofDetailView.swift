import SwiftUI

struct ProofDetailView: View {
    let post: ProofPost

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                proofImageCard
                proofHeader
                verificationSection
                stravaSection
                actionSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Proof detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var proofImageCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.blue.opacity(0.12))
                .frame(height: 220)

            Image(systemName: "clock")
                .font(.system(size: 52))
                .foregroundStyle(Color.blue.opacity(0.65))

            VStack {
                Spacer()

                HStack {
                    Label("Photo verified", systemImage: "checkmark")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.green.opacity(0.95))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.95))
                        .clipShape(Capsule())

                    Spacer()
                }
                .padding(14)
            }
        }
    }

    private var proofHeader: some View {
        HStack(alignment: .center, spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.14))
                .frame(width: 42, height: 42)
                .overlay {
                    Text(initials)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(post.userName)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("\(post.goalTitle) · \(post.timeAgo)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(post.status(votersCount: SampleData.votersCount).displayName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.green)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.green.opacity(0.12))
                .clipShape(Capsule())
        }
    }

    private var verificationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("VERIFICATION CHECKS")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                VerificationCheckRow(
                    title: "Timestamp match",
                    subtitle: "Photo taken 6:42 AM · submitted 6:44 AM",
                    tone: .success
                )

                Divider()

                VerificationCheckRow(
                    title: "No duplicate detected",
                    subtitle: "Unique image, not seen before",
                    tone: .success
                )

                Divider()

                VerificationCheckRow(
                    title: "AI authenticity check",
                    subtitle: "Likely genuine photo",
                    tone: .success
                )

                Divider()

                VerificationCheckRow(
                    title: "Location unverified",
                    subtitle: "GPS not available for this photo",
                    tone: .warning
                )
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            }
        }
    }

    private var stravaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("STRAVA DATA")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Image(systemName: "figure.run")
                    .font(.title3)
                    .foregroundStyle(.green)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Verified via Strava")
                        .font(.headline)
                        .foregroundStyle(Color.green.opacity(0.95))

                    Text("5.1 km · 28:42 · 562 cal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "checkmark")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            .padding(18)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var actionSection: some View {
        HStack(spacing: 12) {
            Button {
            } label: {
                Text("Approve")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            NavigationLink {
                SnitchProofView(post: post)
            } label: {
                Text("Reject")
                    .font(.headline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            Button {
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(width: 54, height: 54)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
        }
    }

    private var initials: String {
        let parts = post.userName.split(separator: " ")
        return parts.compactMap { $0.first }.prefix(2).map { String($0) }.joined()
    }
}

private struct VerificationCheckRow: View {
    enum Tone {
        case success
        case warning
    }

    let title: String
    let subtitle: String
    let tone: Tone

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(iconBackground)
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: iconName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(iconColor)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(subtitleColor)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var iconName: String {
        switch tone {
        case .success:
            return "checkmark"
        case .warning:
            return "exclamationmark"
        }
    }

    private var iconColor: Color {
        switch tone {
        case .success:
            return .green
        case .warning:
            return Color.orange.opacity(0.9)
        }
    }

    private var iconBackground: Color {
        switch tone {
        case .success:
            return Color.green.opacity(0.12)
        case .warning:
            return Color.orange.opacity(0.14)
        }
    }

    private var subtitleColor: Color {
        switch tone {
        case .success:
            return .secondary
        case .warning:
            return Color.orange.opacity(0.95)
        }
    }
}
