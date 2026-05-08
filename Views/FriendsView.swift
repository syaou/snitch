import SwiftUI

struct FriendsView: View {
    @State private var requests: [FriendRequest] = [
        FriendRequest(name: "Alex Johnson", subtitle: "Wants to join your accountability circle"),
        FriendRequest(name: "Sarah Chen", subtitle: "Sent a friend request 3h ago")
    ]
    @State private var suggestions: [FriendSuggestion] = [
        FriendSuggestion(name: "Mike Brown", subtitle: "5 mutual goals"),
        FriendSuggestion(name: "Emma Davis", subtitle: "2 mutual friends"),
        FriendSuggestion(name: "Liam Wilson", subtitle: "Recently joined Snitch")
    ]
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                addPeopleSection
                requestsSection
                suggestionsSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    FriendInviteView()
                } label: {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
    }

    private var addPeopleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add people")
                .font(.headline)

            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search by name or username", text: $searchText)
            }
            .padding(14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            }
        }
    }

    private var requestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pending requests")
                .font(.headline)

            if requests.isEmpty {
                emptyStateCard(text: "No pending requests right now.")
            } else {
                VStack(spacing: 12) {
                    ForEach(requests) { request in
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 12) {
                                avatar(for: request.name, color: .blue)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(request.name)
                                        .font(.headline)

                                    Text(request.subtitle)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }

                            HStack(spacing: 10) {
                                Button {
                                    approve(request)
                                } label: {
                                    Text("Approve")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.green.opacity(0.12))
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .buttonStyle(.plain)

                                Button {
                                    decline(request)
                                } label: {
                                    Text("Decline")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.red)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.red.opacity(0.10))
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.04), radius: 10, y: 4)
                    }
                }
            }
        }
    }

    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested people")
                .font(.headline)

            VStack(spacing: 12) {
                ForEach(filteredSuggestions) { suggestion in
                    HStack(spacing: 12) {
                        avatar(for: suggestion.name, color: .green)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(suggestion.name)
                                .font(.headline)

                            Text(suggestion.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            add(suggestion)
                        } label: {
                            Text("Add")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.04), radius: 10, y: 4)
                }
            }
        }
    }

    private var filteredSuggestions: [FriendSuggestion] {
        if searchText.isEmpty {
            return suggestions
        }

        return suggestions.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func approve(_ request: FriendRequest) {
        requests.removeAll { $0.id == request.id }
    }

    private func decline(_ request: FriendRequest) {
        requests.removeAll { $0.id == request.id }
    }

    private func add(_ suggestion: FriendSuggestion) {
        suggestions.removeAll { $0.id == suggestion.id }
    }

    private func avatar(for name: String, color: Color) -> some View {
        Circle()
            .fill(color.opacity(0.14))
            .frame(width: 42, height: 42)
            .overlay {
                Text(initials(for: name))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
            }
    }

    private func initials(for name: String) -> String {
        let parts = name.split(separator: " ")
        return parts.compactMap { $0.first }.prefix(2).map(String.init).joined()
    }

    private func emptyStateCard(text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct FriendRequest: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
}

private struct FriendSuggestion: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
}
