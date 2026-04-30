import SwiftUI
import PhotosUI

struct UploadProofView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedGoal = "Gym Day 3"
    @State private var notes = ""

    private let goals = ["Gym Day 3", "Read 30 minutes", "Morning Run 5K", "Meal Prep Sunday"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Upload Proof")
                        .font(.system(size: 26, weight: .bold))

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

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Goal")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Picker("Choose a goal", selection: $selectedGoal) {
                            ForEach(goals, id: \.self) { goal in
                                Text(goal)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

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

                    Button {
                        // Submit proof logic later
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Submit Proof")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedImage == nil ? Color.gray.opacity(0.45) : Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(selectedImage == nil)
                    .padding(.top, 8)
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
                    }
                }
            }
        }
    }
}

#Preview {
    UploadProofView()
}
