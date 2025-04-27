import Foundation
import Combine
import os

@MainActor
final class LibraryViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case ready(albums: [Album])
        case failed(Error)
    }

    // Published
    @Published private(set) var state: State = .idle

    // Dependencies
    private let fetchLibrary: FetchLibraryUseCase
    private let playTrack: PlayTrackUseCase

    // Cache
    private var snapshot: MusicLibrarySnapshot?

    private let log = Logger(category: "LibraryViewModel")

    init(fetchLibrary: FetchLibraryUseCase, playTrack: PlayTrackUseCase) {
        self.fetchLibrary = fetchLibrary
        self.playTrack = playTrack
    }

    @available(macOS 14.0, *)
    func onAppear() {
        guard case .idle = state else { return }
        Task { await loadLibrary() }
    }

    @available(macOS 14.0, *)
    private func loadLibrary() async {
        state = .loading
        do {
            snapshot = try await fetchLibrary()
            log.info("Fetched library with \(snapshot?.albums.count ?? 0) albums")
            state = .ready(albums: snapshot?.albums ?? [])
        } catch {
            log.error("Failed to fetch library: \(error.localizedDescription)")
            state = .failed(error)
        }
    }

    @available(macOS 14.0, *)
    func didSelectTrack(_ song: Song) {
        Task {
            try? await playTrack(track: song)
        }
    }

    func songs(for album: Album) -> [Song] {
        guard let snapshot else { return [] }
        return snapshot.songs.filter { $0.albumId == album.id }
    }
}
 
