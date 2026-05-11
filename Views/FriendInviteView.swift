import SwiftUI

struct FriendInviteView: View {
    @Environment(\.dismiss) private var dismiss
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
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .background(AppColours.canvas)
        .navigationBarHidden(true)
    }

    private var headerView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Invite a friend")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(AppColours.ink)

                Text("Share this link so they can join your group and start reviewing proof.")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppColours.muted)
            }

            Spacer()

            closeButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var closeButton: some View {
        Button {
            if let onDone {
                onDone()
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.headline.weight(.black))
                .foregroundStyle(AppColours.ink)
                .frame(width: 38, height: 38)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.top, 2)
    }

    private var linkCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Invite Link", systemImage: "paperclip")
                .font(.caption.weight(.black))
                .foregroundStyle(AppColours.ink)

            Text(inviteURL.absoluteString)
                .font(.system(.caption, design: .monospaced).weight(.semibold))
                .foregroundStyle(AppColours.muted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .stampCard(background: AppColours.paper, shadowOffset: 2)
        }
        .padding(16)
        .stampCard(background: AppColours.cream, shadowOffset: 3)
    }

    private var copyButton: some View {
        AppButton(kind: .secondary) {
            UIPasteboard.general.string = inviteURL.absoluteString
        } label: {
            Label("Copy link", systemImage: "doc.on.doc")
        }
    }

}
