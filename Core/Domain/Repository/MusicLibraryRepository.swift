import Foundation

public protocol MusicLibraryRepository {
    func library() async throws -> MusicLibrarySnapshot
    func play(track: Song) async throws
} 