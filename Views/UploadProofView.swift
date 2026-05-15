import SwiftUI
import PhotosUI
import UIKit

struct UploadProofView: View {
    @EnvironmentObject var feedViewModel: FeedViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @EnvironmentObject var groupsViewModel: GroupsViewModel

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedImageData: Data?
    @State private var selectedGoal: Goal?
    @State private var notes = ""
    @State private var notesError: ProofPost.ValidationError?
    @State private var showSuccessAlert = false
    @State private var showingCamera = false
    @State private var validationMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Kicker(text: groupsViewModel.activeGroup?.name ?? "Active group")

                                Text("Upload Proof")
                                    .font(.system(size: 34, weight: .black))
                                    .foregroundStyle(AppColours.ink)
                            }

                            Spacer()
                        }

                        Text("Add a photo, pick the goal, then send it for review.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppColours.muted)
                    }

                    photoSection
                    goalSection
                    notesSection
                    submitButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 90)
            }
            .background(AppColours.mustard)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showingCamera) {
                CameraPickerView { image in
                    selectedImage = Image(uiImage: image)
                    selectedImageData = image.jpegData(compressionQuality: 0.85)
                    showingCamera = false
                } onCancel: {
                    showingCamera = false
                }
                .ignoresSafeArea()
            }
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                        selectedImageData = data
                        validationMessage = nil
                    } else if selectedItem != nil {
                        validationMessage = "That photo couldn't be loaded. Try a different image."
                    }
                }
            }
            .onAppear {
                refreshSelectedGoal()
            }
            .onChange(of: groupsViewModel.activeGroupId) {
                refreshSelectedGoal()
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
                .fontWeight(.black)
                .foregroundStyle(AppColours.ink)

            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(AppColours.cardBackground)
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundStyle(AppColours.ink.opacity(0.35))
                        }
                        .frame(height: 210)

                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFill()
                            .frame(height: 210)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "camera")
                                .font(.system(size: 34))
                                .foregroundStyle(AppColours.ink)

                        Text("Tap to upload photo")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(AppColours.muted)
                        }
                    }
                }
            }
            .stampCard(background: AppColours.cream, shadowOffset: 3)

            if cameraAvailable {
                AppButton(kind: .secondary) {
                    showingCamera = true
                } label: {
                    Label("Take Photo", systemImage: "camera.fill")
                }
            }

            if selectedImage == nil, let validationMessage {
                validationText(validationMessage)
            }
        }
    }

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Goal")
                .font(.subheadline)
                .fontWeight(.black)
                .foregroundStyle(AppColours.ink)

            if visibleGoals.isEmpty {
                Text("Add a goal first on the Goals tab")
                    .font(.subheadline)
                    .foregroundStyle(AppColours.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .stampCard(background: AppColours.cream, shadowOffset: 2)
            } else {
                Picker("Choose a goal", selection: $selectedGoal) {
                    ForEach(visibleGoals) { goal in
                        Text(goal.title).tag(goal as Goal?)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .stampCard(background: AppColours.cream, shadowOffset: 2)
            }

            if selectedGoal == nil, let validationMessage {
                validationText(validationMessage)
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notes (Optional)")
                .font(.subheadline)
                .fontWeight(.black)
                .foregroundStyle(AppColours.ink)

            TextField("Add any details about your progress...", text: $notes, axis: .vertical)
                .lineLimit(4, reservesSpace: true)
                .padding()
                .stampCard(background: AppColours.cream, shadowOffset: 2)
                .onChange(of: notes) { _, newValue in
                    notesError = ProofPost.validateNotes(newValue)
                }

            if let notesError {
                validationText(notesError.rawValue)
            }
        }
    }

    private var submitButton: some View {
        VStack(alignment: .leading, spacing: 8) {
            AppButton(kind: .primary, disabled: !canSubmit) {
                submit()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Submit Proof")
                }
            }
            .disabled(!canSubmit)

            if let message = validationMessage ?? proofValidationMessage {
                validationText(message)
            }
        }
        .padding(.top, 8)
    }

    private var canSubmit: Bool {
        guard selectedImageData != nil, let selectedGoal else { return false }
        guard notesError == nil else { return false }
        return visibleGoals.contains { $0.id == selectedGoal.id }
    }

    private var cameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    private var visibleGoals: [Goal] {
        guard let activeGroupId = groupsViewModel.activeGroupId else {
            return goalsViewModel.goals
        }
        return goalsViewModel.goals.filter { $0.groupId == activeGroupId }
    }

    private func submit() {
        validationMessage = proofValidationMessage
        guard validationMessage == nil,
              let goal = selectedGoal,
              let proofImageData = selectedImageData else { return }

        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let post = ProofPost(
            userId: SampleData.profile.id,
            userName: SampleData.profile.name,
            goalId: goal.id,
            goalTitle: goal.title,
            groupId: goal.groupId,
            iconName: "photo.fill",
            createdAt: Date(),
            photoData: proofImageData,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes
        )
        feedViewModel.add(post)

        selectedImage = nil
        selectedItem = nil
        selectedImageData = nil
        notes = ""
        selectedGoal = visibleGoals.first
        showSuccessAlert = true
    }

    private var proofValidationMessage: String? {
        if visibleGoals.isEmpty {
            return "Add a goal before uploading proof."
        }
        if selectedGoal == nil {
            return "Choose which goal this proof belongs to."
        }
        if selectedImageData == nil {
            return "Add a photo before submitting proof."
        }
        if let selectedGoal, !visibleGoals.contains(where: { $0.id == selectedGoal.id }) {
            return "That goal is no longer in the active group. Pick another goal."
        }
        return nil
    }

    private func refreshSelectedGoal() {
        if let selectedGoal,
           visibleGoals.contains(where: { $0.id == selectedGoal.id }) {
            return
        }
        selectedGoal = visibleGoals.first
    }

    private func validationText(_ message: String) -> some View {
        Text(message)
            .font(.caption.weight(.bold))
            .foregroundStyle(AppColours.warning)
    }
}
