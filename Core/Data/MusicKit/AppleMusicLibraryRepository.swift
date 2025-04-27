import Foundation
import MusicKit

public final class AppleMusicLibraryRepository: MusicLibraryRepository {

    public init() {}

    // MARK: - MusicLibraryRepository
    public func library() async throws -> MusicLibrarySnapshot {
        // 1. Request user permission if needed
        switch await MusicAuthorization.currentStatus {
        case .notDetermined:
            let status = await MusicAuthorization.request()
            guard status == .authorized else { throw MusicAuthorizationError.notAuthorized }
        case .denied, .restricted:
            throw MusicAuthorizationError.notAuthorized
        case .authorized: break
        @unknown default:
            throw MusicAuthorizationError.unknown
        }

        // 2. Fetch songs, albums, artists concurrently
        async let songsResponse = fetchSongs()
        async let albumsResponse = fetchAlbums()
        async let artistsResponse = fetchArtists()

        let (songs, albums, artists) = try await (songsResponse, albumsResponse, artistsResponse)
        return .init(songs: songs, albums: albums, artists: artists)
    }

    public func play(track: Song) async throws {
        let player = ApplicationMusicPlayer.shared
        let musicID = MusicItemID(track.id)
        let musicItem = MusicKit.Song(id: musicID)
        try await player.queue = [musicItem]
        try await player.play()
    }
}

// MARK: - Helpers

private extension AppleMusicLibraryRepository {
    func fetchSongs() async throws -> [Song] {
        let request = MusicLibraryRequest<MusicKit.Song>()
        let response = try await request.response()
        return response.items.map(Song.init(musicSong:))
    }

    func fetchAlbums() async throws -> [Album] {
        let request = MusicLibraryRequest<MusicKit.Album>()
        let response = try await request.response()
        return response.items.map(Album.init(musicAlbum:))
    }

    func fetchArtists() async throws -> [Artist] {
        let request = MusicLibraryRequest<MusicKit.Artist>()
        let response = try await request.response()
        return response.items.map(Artist.init(musicArtist:))
    }
}

// MARK: - Mapping Extensions

private extension Song {
    init(musicSong: MusicKit.Song) {
        self.init(
            id: musicSong.id.rawValue,
            title: musicSong.title,
            artistName: musicSong.artistName,
            albumId: musicSong.album?.id.rawValue ?? "",
            duration: musicSong.duration ?? 0,
            artworkURL: musicSong.artwork?.url(width: 200, height: 200)
        )
    }
}

private extension Album {
    init(musicAlbum: MusicKit.Album) {
        self.init(
            id: musicAlbum.id.rawValue,
            title: musicAlbum.title,
            artistName: musicAlbum.artistName,
            artworkURL: musicAlbum.artwork?.url(width: 400, height: 400),
            songIDs: []
        )
    }
}

private extension Artist {
    init(musicArtist: MusicKit.Artist) {
        self.init(
            id: musicArtist.id.rawValue,
            name: musicArtist.name,
            artworkURL: musicArtist.artwork?.url(width: 400, height: 400),
            albumIDs: []
        )
    }
}

// MARK: - Errors

public enum MusicAuthorizationError: Error {
    case notAuthorized
    case unknown
} 