public struct PlayTrackUseCase {
    private let repository: MusicLibraryRepository

    public init(repository: MusicLibraryRepository) {
        self.repository = repository
    }

    @available(macOS 14.0, *)
    public func callAsFunction(track: Song) async throws {
        try await repository.play(track: track)
    }
} 
