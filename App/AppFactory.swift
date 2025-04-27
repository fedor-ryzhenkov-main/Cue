import SwiftUI

enum AppFactory {
    private static let repository: MusicLibraryRepository = AppleMusicLibraryRepository()

    @available(macOS 14.0, *)
    @MainActor
    static func libraryView() -> some View {
        let fetchUseCase = FetchLibraryUseCase(repository: repository)
        let playUseCase = PlayTrackUseCase(repository: repository)
        let viewModel = LibraryViewModel(fetchLibrary: fetchUseCase, playTrack: playUseCase)
        return LibraryView(viewModel: viewModel)
    }
} 
