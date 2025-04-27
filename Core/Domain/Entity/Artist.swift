import Foundation

public struct Artist: Identifiable, Equatable, Hashable {
    public let id: MusicItemID
    public let name: String
    public let artworkURL: URL?
    public let albumIDs: [MusicItemID]

    public init(id: MusicItemID,
                name: String,
                artworkURL: URL?,
                albumIDs: [MusicItemID]) {
        self.id = id
        self.name = name
        self.artworkURL = artworkURL
        self.albumIDs = albumIDs
    }
} 