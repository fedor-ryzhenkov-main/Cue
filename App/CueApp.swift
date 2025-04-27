import SwiftUI
import SwiftData

@main
@available(macOS 14.0, *)
struct CueApp: App {
    var body: some Scene {
        WindowGroup {
            AppFactory.libraryView()
        }
    }
} 
