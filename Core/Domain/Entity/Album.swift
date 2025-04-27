import Foundation

public struct Album: Identifiable, Equatable, Hashable {
    public let id: EntityID
    public let title: String
    public let artistName: String
    public let artworkURL: URL?
    public let songIDs: [EntityID]

    public init(id: EntityID,
                title: String,
                artistName: String,
                artworkURL: URL?,
                songIDs: [EntityID]) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.artworkURL = artworkURL
        self.songIDs = songIDs
    }
} 
