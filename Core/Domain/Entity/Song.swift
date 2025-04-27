import Foundation

public struct Song: Identifiable, Equatable, Hashable {
    public let id: EntityID
    public let title: String
    public let artistName: String
    public let albumId: EntityID
    public let duration: TimeInterval
    public let artworkURL: URL?

    public init(id: EntityID,
                title: String,
                artistName: String,
                albumId: EntityID,
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
