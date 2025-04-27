import XCTest
@testable import Cue

final class LibraryViewModelTests: XCTestCase {

    func test_onAppear_fetchesLibraryAndUpdatesState() async {
        // Given
        let snapshot = MusicLibrarySnapshot(
            songs: [Song(id: "1", title: "Song", artistName: "Artist", albumId: "A1", duration: 120, artworkURL: nil)],
            albums: [Album(id: "A1", title: "Album", artistName: "Artist", artworkURL: nil, songIDs: ["1"])],
            artists: []
        )
        let repo = StubRepository(snapshot: snapshot)
        let viewModel = LibraryViewModel(fetchLibrary: .init(repository: repo), playTrack: .init(repository: repo))

        // When
        viewModel.onAppear()

        // Then: wait briefly for async task
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s

        guard case .ready(let albums) = viewModel.state else {
            XCTFail("State should be ready")
            return
        }
        XCTAssertEqual(albums, snapshot.albums)
    }

    func test_didSelectTrack_callsPlayUseCase() async {
        // Given
        let snapshot = MusicLibrarySnapshot(songs: [], albums: [], artists: [])
        let repo = StubRepository(snapshot: snapshot)
        let viewModel = LibraryViewModel(fetchLibrary: .init(repository: repo), playTrack: .init(repository: repo))

        let song = Song(id: "1", title: "Song", artistName: "Artist", albumId: "A1", duration: 120, artworkURL: nil)

        // When
        viewModel.didSelectTrack(song)

        // Then
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(repo.playedTrack?.id, song.id)
    }
}

private final class StubRepository: MusicLibraryRepository {
    var snapshot: MusicLibrarySnapshot
    init(snapshot: MusicLibrarySnapshot) { self.snapshot = snapshot }

    var playedTrack: Song?

    func library() async throws -> MusicLibrarySnapshot { snapshot }

    func play(track: Song) async throws { playedTrack = track }
} 