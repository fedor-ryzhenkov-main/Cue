import OSLog

public struct Logger {
    private let logger: os.Logger

    public init(category: String = "General") {
        logger = .init(subsystem: Bundle.main.bundleIdentifier ?? "Cue", category: category)
    }

    public func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    public func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    public func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
} 