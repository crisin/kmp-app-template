import SwiftUI

/// Photo gallery screen — demonstrates image capture/pick workflow.
///
/// Simulates the capture/pick workflow with placeholder data.
/// Wire up UIImagePickerController or PHPickerViewController
/// for real image selection.
struct CameraView: View {
    @State private var photos: [SavedPhoto] = []
    @State private var photoToDelete: SavedPhoto?
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // Action buttons
            HStack(spacing: 12) {
                Button {
                    addPhoto(name: "Photo \(photos.count + 1)")
                } label: {
                    Text("Take Photo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    addPhoto(name: "Import \(photos.count + 1)")
                } label: {
                    Text("Pick Image")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding()

            if photos.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Text("📷")
                        .font(.system(size: 48))
                    Text("No photos yet")
                        .font(.headline)
                    Text("Take a photo or pick one from your gallery")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                Text("\(photos.count) photo\(photos.count == 1 ? "" : "s") saved")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 140), spacing: 8)
                    ], spacing: 8) {
                        ForEach(photos) { photo in
                            PhotoCard(photo: photo) {
                                photoToDelete = photo
                                showDeleteAlert = true
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Photos")
        .alert("Delete Photo", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let photo = photoToDelete {
                    photos.removeAll { $0.id == photo.id }
                }
                photoToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                photoToDelete = nil
            }
        } message: {
            Text("Remove \"\(photoToDelete?.name ?? "")\" from saved photos?")
        }
    }

    private func addPhoto(name: String) {
        let photo = SavedPhoto(
            id: UUID().uuidString,
            name: name,
            timestamp: Date(),
            sizeKb: Int.random(in: 100...2048)
        )
        photos.append(photo)
    }
}

struct SavedPhoto: Identifiable {
    let id: String
    let name: String
    let timestamp: Date
    let sizeKb: Int
}

private struct PhotoCard: View {
    let photo: SavedPhoto
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.purple.opacity(0.15))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Text("🖼️")
                            .font(.largeTitle)
                    }

                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Circle().fill(.white))
                }
                .padding(6)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(photo.name)
                    .font(.subheadline)
                    .lineLimit(1)
                Text("\(photo.sizeKb) KB")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(8)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        CameraView()
    }
}
