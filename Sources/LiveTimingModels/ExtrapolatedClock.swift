import Foundation

public struct ExtrapolatedClock: Codable, Sendable {
    public let utc: Date
    public let remaining: String?
    public let extrapolating: Bool?

    public init(remaining: String?, extrapolating: Bool?) {
        self.utc = Date.now
        self.remaining = remaining
        self.extrapolating = extrapolating
    }

    enum CodingKeys: String, CodingKey {
        case remaining = "Remaining"
        case extrapolating = "Extrapolating"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.utc = Date.now
        self.remaining = try container.decodeIfPresent(String.self, forKey: .remaining)
        self.extrapolating = try container.decodeIfPresent(Bool.self, forKey: .extrapolating)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(remaining, forKey: .remaining)
        try container.encodeIfPresent(extrapolating, forKey: .extrapolating)
    }
}

extension ExtrapolatedClock {
    public static var empty: Self { .init(remaining: nil, extrapolating: nil) }
}
