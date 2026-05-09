import SwiftUI
import PhotosUI

struct UploadProofView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedImageData: Data?
    @State private var selectedGoal: Goal?
    @State private var notes = ""
    @State private var showSuccessAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Upload Proof")
                        .font(.system(size: 26, weight: .bold))

                    photoSection
                    goalSection
                    notesSection
                    submitButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 90)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                        selectedImageData = data
                    }
                }
            }
            .onAppear {
                if selectedGoal == nil {
                    selectedGoal = goalsViewModel.goals.first
                }
            }
            .alert("Proof submitted!", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Head to the Feed to see it. Your friends will vote on it.")
            }
        }
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Photo Evidence")
                .font(.subheadline)
                .fontWeight(.medium)

            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.blue.opacity(0.04))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundStyle(Color.gray.opacity(0.35))
                        }
                        .frame(height: 210)

                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFill()
                            .frame(height: 210)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "camera")
                                .font(.system(size: 34))
                                .foregroundStyle(.gray)

                            Text("Tap to upload photo")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Goal")
                .font(.subheadline)
                .fontWeight(.medium)

            if goalsViewModel.goals.isEmpty {
                Text("Add a goal first on the Goals tab")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                Picker("Choose a goal", selection: $selectedGoal) {
                    ForEach(goalsViewModel.goals) { goal in
                        Text(goal.title).tag(goal as Goal?)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notes (Optional)")
                .font(.subheadline)
                .fontWeight(.medium)

            TextField("Add any details about your progress...", text: $notes, axis: .vertical)
                .lineLimit(4, reservesSpace: true)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var submitButton: some View {
        Button {
            submit()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Submit Proof")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(canSubmit ? Color.black : Color.gray.opacity(0.45))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!canSubmit)
        .padding(.top, 8)
    }

    private var canSubmit: Bool {
        selectedImage != nil && selectedGoal != nil
    }

    private func submit() {
        guard let goal = selectedGoal else { return }

        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let post = ProofPost(
            userId: SampleData.profile.id,
            userName: SampleData.profile.name,
            goalId: goal.id,
            goalTitle: goal.title,
            groupId: SampleData.defaultGroup.id,
            iconName: "photo.fill",
            createdAt: Date(),
            photoData: selectedImageData,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes
        )
        feedViewModel.add(post)

        selectedImage = nil
        selectedItem = nil
        selectedImageData = nil
        notes = ""
        selectedGoal = goalsViewModel.goals.first
        showSuccessAlert = true
    }
}
