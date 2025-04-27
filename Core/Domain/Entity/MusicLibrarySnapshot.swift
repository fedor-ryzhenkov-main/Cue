public struct MusicLibrarySnapshot: Equatable, Hashable {
    public let songs: [Song]
    public let albums: [Album]
    public let artists: [Artist]

    public init(songs: [Song] = [],
                albums: [Album] = [],
                artists: [Artist] = []) {
        self.songs = songs
        self.albums = albums
        self.artists = artists
    }
} 