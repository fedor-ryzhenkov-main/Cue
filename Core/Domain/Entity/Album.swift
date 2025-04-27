import Foundation

public struct Album: Identifiable, Equatable, Hashable {
    public let id: MusicItemID
    public let title: String
    public let artistName: String
    public let artworkURL: URL?
    public let songIDs: [MusicItemID]

    public init(id: MusicItemID,
                title: String,
                artistName: String,
                artworkURL: URL?,
                songIDs: [MusicItemID]) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.artworkURL = artworkURL
        self.songIDs = songIDs
    }
} 