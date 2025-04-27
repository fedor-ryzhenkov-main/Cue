import Foundation
import MusicKit

public final class AppleMusicLibraryRepository: MusicLibraryRepository {

    public init() {}

    // MARK: - MusicLibraryRepository

    @available(macOS 14.0, *)
    public func library() async throws -> MusicLibrarySnapshot {
        switch MusicAuthorization.currentStatus {
        case .notDetermined:
            let status = await MusicAuthorization.request()
            guard status == .authorized else { throw MusicAuthorizationError.notAuthorized }
        case .denied, .restricted:
            throw MusicAuthorizationError.notAuthorized
        case .authorized: break
        @unknown default:
            throw MusicAuthorizationError.unknown
        }

        async let songsResponse = fetchSongs()
        async let albumsResponse = fetchAlbums()
        async let artistsResponse = fetchArtists()

        let (songs, albums, artists) = try await (songsResponse, albumsResponse, artistsResponse)
        return .init(songs: songs, albums: albums, artists: artists)
    }

    @available(macOS 14.0, *)
    public func play(track: Song) async throws {
        let player = ApplicationMusicPlayer.shared
 
        let request  = MusicCatalogResourceRequest<MusicKit.Song>(
                         matching: \.id,
                         equalTo : MusicKit.MusicItemID(track.id))

        let response = try await request.response()
        guard let musicKitSong = response.items.first else {
            throw MusicAuthorizationError.unknown
        }

        player.queue = ApplicationMusicPlayer.Queue(for: [musicKitSong])

        try await player.play()
    }
}

// MARK: - Helpers

@available(macOS 14.0, *)
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
    @available(macOS 14.0, *)
    init(musicSong: MusicKit.Song) {
        let albumID = ""

        self.init(
            id: musicSong.id.rawValue,
            title: musicSong.title,
            artistName: musicSong.artistName,
            albumId: albumID,
            duration: musicSong.duration ?? 0,
            artworkURL: musicSong.artwork?.url(width: 200, height: 200)
        )
    }
}

private extension Album {

    @available(macOS 14.0, *)
    init(musicAlbum: MusicKit.Album) {
        self.init(
            id: musicAlbum.id.rawValue,
            title: musicAlbum.title,
            artistName: musicAlbum.artistName,
            artworkURL: musicAlbum.artwork?.url(width: 400, height: 400),
            songIDs: [] // Placeholder - requires fetching album.tracks relationship
        )
    }
}

private extension Artist {
    @available(macOS 14.0, *)
    init(musicArtist: MusicKit.Artist) {
        self.init(
            id: musicArtist.id.rawValue,
            name: musicArtist.name,
            artworkURL: musicArtist.artwork?.url(width: 400, height: 400),
            albumIDs: [] // Placeholder - requires fetching artist.albums relationship
        )
    }
}

// MARK: - Errors

public enum MusicAuthorizationError: Error {
    case notAuthorized
    case unknown
} 
