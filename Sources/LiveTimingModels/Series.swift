import Foundation

public struct Series: Codable, Sendable {
    public let utc: String
    public let lap: Int?
    /// Qualifying part (1–3) that started at `utc`; 0 before Q1.
    public let qualifyingPart: Int?

    enum CodingKeys: String, CodingKey {
        case utc = "Utc"
        case lap = "Lap"
        case qualifyingPart = "QualifyingPart"
    }
}
