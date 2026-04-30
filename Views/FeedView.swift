import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var selectedFilter = "All"

    private let filters = ["All", "Pending", "Approved"]

    private var filteredPosts: [ProofPost] {
        if selectedFilter == "All" {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { $0.status == selectedFilter }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("THURSDAY")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            Text("Feed")
                                .font(.system(size: 34, weight: .bold))
                        }

                        Spacer()

                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 46, height: 46)
                            .overlay {
                                Image(systemName: "bell")
                                    .foregroundStyle(.blue)
                            }
                    }

                    HStack(spacing: 10) {
                        ForEach(filters, id: \.self) { filter in
                            Text(filterTitle(filter))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(selectedFilter == filter ? Color.black : Color(.systemGray6))
                                .foregroundStyle(selectedFilter == filter ? .white : .primary)
                                .clipShape(Capsule())
                                .onTapGesture {
                                    selectedFilter = filter
                                }
                        }
                    }

                    Text("RECENT PROOF POSTS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)

                    ForEach(filteredPosts) { post in
                        ProofCardView(post: post)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 90)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func filterTitle(_ filter: String) -> String {
        if filter == "Pending" {
            let count = viewModel.posts.filter { $0.status == "Pending" }.count
            return "Pending (\(count))"
        }

        return filter
    }
}

#Preview {
    FeedView()
}
