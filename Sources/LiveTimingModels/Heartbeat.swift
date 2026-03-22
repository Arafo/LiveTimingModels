import Foundation

public struct Heartbeat: Codable, Sendable {
    public let utc: String
    public let kf: Bool?

    public init(utc: String, kf: Bool?) {
        self.utc = utc
        self.kf = kf
    }

    enum CodingKeys: String, CodingKey {
        case utc = "Utc"
        case kf = "_kf"
    }
}

extension Heartbeat {
    public static var empty: Self { .init(utc: "", kf: false) }
}
