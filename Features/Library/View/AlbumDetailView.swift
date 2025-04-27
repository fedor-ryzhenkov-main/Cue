import SwiftUI

@available(macOS 14.0, *)
struct AlbumDetailView: View {
    let album: Album
    @ObservedObject var viewModel: LibraryViewModel

    var body: some View {
        List(viewModel.songs(for: album)) { song in
            Button(action: { viewModel.didSelectTrack(song) }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(song.title)
                        Text(song.artistName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(format(duration: song.duration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(album.title)
    }

    private func format(duration: TimeInterval) -> String {
        let mins = Int(duration) / 60
        let secs = Int(duration) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}
