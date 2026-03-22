import Foundation

public struct TimingStats: Codable, Sendable {
    public let withheld: Bool?
    public var lines: [String: TimingStatsLine]
    public let sessionType: String?
    public let kf: Bool?

    public init(
        withheld: Bool? = nil,
        lines: [String: TimingStatsLine] = [:],
        sessionType: String? = nil,
        kf: Bool? = nil
    ) {
        self.withheld = withheld
        self.lines = lines
        self.sessionType = sessionType
        self.kf = kf
    }

    enum CodingKeys: String, CodingKey {
        case withheld = "Withheld"
        case lines = "Lines"
        case sessionType = "SessionType"
        case kf = "_kf"
    }
}

extension TimingStats {
    public static var empty: Self { .init(withheld: false, lines: [:], sessionType: "", kf: false) }
}

extension TimingStats {
    public mutating func merge(with delta: TimingStats) {
        for (stat, newLine) in delta.lines {
            if lines[stat] != nil {
                lines[stat] = newLine
            } else {
                lines[stat] = newLine
            }
        }
    }
}

public struct TimingStatsLine: Codable, Sendable {
    public let line: Int?
    public let racingNumber: String?
    public let personalBestLapTime: PersonalBestLapTime?
    public let bestSectors: TimingStatsLineBestSector?
    public let bestSpeeds: BestSpeeds?

    enum CodingKeys: String, CodingKey {
        case line = "Line"
        case racingNumber = "RacingNumber"
        case personalBestLapTime = "PersonalBestLapTime"
        case bestSectors = "BestSectors"
        case bestSpeeds = "BestSpeeds"
    }
}

public enum TimingStatsLineBestSector: Codable, Sendable {
    case array([BestSector])
    case dictionary([String: BestSector])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let arr = try? container.decode([BestSector].self) {
            self = .array(arr)
            return
        }

        if let dict = try? container.decode([String: BestSector].self) {
            self = .dictionary(dict)
            return
        }

        if container.decodeNil() {
            self = .array([])
            return
        }

        throw DecodingError.typeMismatch(
            TimingStatsLineBestSector.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected array or dictionary for TimingStatsLineBestSector"
            )
        )
    }
}

public struct BestSector: Codable, Sendable {
    public let value: String?
    public let position: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case position = "Position"
    }
}

public struct BestSpeeds: Codable, Sendable {
    public let i1: BestSector?
    public let i2: BestSector?
    public let fl: BestSector?
    public let st: BestSector?

    enum CodingKeys: String, CodingKey {
        case i1 = "I1"
        case i2 = "I2"
        case fl = "FL"
        case st = "ST"
    }
}

public struct PersonalBestLapTime: Codable, Sendable {
    public let value: String?
    public let lap: Int?
    public let position: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case lap = "Lap"
        case position = "Position"
    }
}
