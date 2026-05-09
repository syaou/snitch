import SwiftUI

struct FriendInviteView: View {
    var onDone: (() -> Void)? = nil

    @State private var token: UUID = UUID()

    private var inviteURL: URL {
        URL(string: "https://snitch.app/invite/\(token.uuidString)")!
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                headerView
                linkCard
                copyButton
                shareButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Invite a friend")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let onDone {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { onDone() }
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Invite a friend to your group")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text("Send this link to add them to your group.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var linkCard: some View {
        Text(inviteURL.absoluteString)
            .font(.system(.subheadline, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            }
    }

    private var copyButton: some View {
        Button {
            UIPasteboard.general.string = inviteURL.absoluteString
        } label: {
            Label("Copy link", systemImage: "doc.on.doc")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private var shareButton: some View {
        ShareLink(item: inviteURL) {
            Label("Share link", systemImage: "square.and.arrow.up")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
