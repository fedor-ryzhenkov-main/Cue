public struct FetchLibraryUseCase {
    private let repository: MusicLibraryRepository

    public init(repository: MusicLibraryRepository) {
        self.repository = repository
    }

    @available(macOS 14.0, *)
    public func callAsFunction() async throws -> MusicLibrarySnapshot {
        try await repository.library()
    }
} 
