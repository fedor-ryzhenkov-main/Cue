// Domain identifier types shared across entities.
// Keeping domain decoupled from MusicKit; using String-based IDs.

public typealias EntityID = String
@available(*, deprecated, renamed: "EntityID")
public typealias MusicItemID = EntityID 