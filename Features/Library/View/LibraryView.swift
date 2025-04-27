import SwiftUI

@available(macOS 14.0, *)
struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Library")
        }
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let error):
            VStack {
                Text("Error: \(error.localizedDescription)")
                Button("Retry") { viewModel.onAppear() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .ready(let albums):
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                    ForEach(albums) { album in
                        NavigationLink(destination: AlbumDetailView(album: album, viewModel: viewModel)) {
                            AlbumGridItem(album: album)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

@available(macOS 14.0, *)
struct AlbumGridItem: View {
    let album: Album

    var body: some View {
        VStack {
            AsyncImage(url: album.artworkURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                        )
                }
            }
            .frame(height: 160)

            Text(album.title)
                .font(.headline)
                .lineLimit(1)
            Text(album.artistName)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}

#Preview {
    if #available(macOS 14.0, *) {
        LibraryView(viewModel: LibraryViewModel(fetchLibrary: .init(repository: PreviewRepository()),
                                                playTrack: .init(repository: PreviewRepository())))
    } else {
        // Fallback on earlier versions
    }
}

// MARK: - Preview Repository

private final class PreviewRepository: MusicLibraryRepository {
    func library() async throws -> MusicLibrarySnapshot {
        .init(songs: [], albums: [Album(id: "1", title: "Album One", artistName: "Artist", artworkURL: nil, songIDs: [])], artists: [])
    }
    func play(track: Song) async throws {}
} 
