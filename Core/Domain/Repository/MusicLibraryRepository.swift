import Foundation

public protocol MusicLibraryRepository {
    @available(macOS 14.0, *)
    func library() async throws -> MusicLibrarySnapshot
 
    @available(macOS 14.0, *)
    func play(track: Song) async throws
} 