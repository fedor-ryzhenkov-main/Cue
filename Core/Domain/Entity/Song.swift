import Foundation

public struct Song: Identifiable, Equatable, Hashable {
    public let id: MusicItemID
    public let title: String
    public let artistName: String
    public let albumId: MusicItemID
    public let duration: TimeInterval
    public let artworkURL: URL?

    public init(id: MusicItemID,
                title: String,
                artistName: String,
                albumId: MusicItemID,
                duration: TimeInterval,
                artworkURL: URL?) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.albumId = albumId
        self.duration = duration
        self.artworkURL = artworkURL
    }
} 