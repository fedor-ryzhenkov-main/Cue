import Foundation

public struct Artist: Identifiable, Equatable, Hashable {
    public let id: EntityID
    public let name: String
    public let artworkURL: URL?
    public let albumIDs: [EntityID]

    public init(id: EntityID,
                name: String,
                artworkURL: URL?,
                albumIDs: [EntityID]) {
        self.id = id
        self.name = name
        self.artworkURL = artworkURL
        self.albumIDs = albumIDs
    }
} 
