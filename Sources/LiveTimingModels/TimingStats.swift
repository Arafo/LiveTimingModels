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
            if let existing = lines[stat] {
                lines[stat] = existing.merging(newLine)
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

extension TimingStatsLine {
    func merging(_ delta: TimingStatsLine) -> TimingStatsLine {
        TimingStatsLine(
            line: delta.line ?? line,
            racingNumber: delta.racingNumber ?? racingNumber,
            personalBestLapTime: personalBestLapTime?.merging(delta.personalBestLapTime) ?? delta.personalBestLapTime,
            bestSectors: bestSectors?.merging(delta.bestSectors) ?? delta.bestSectors,
            bestSpeeds: bestSpeeds?.merging(delta.bestSpeeds) ?? delta.bestSpeeds
        )
    }
}

extension TimingStatsLineBestSector {
    func merging(_ delta: TimingStatsLineBestSector?) -> TimingStatsLineBestSector {
        guard let delta else { return self }

        var merged = dictionary
        for (key, deltaSector) in delta.dictionary {
            if let existingSector = merged[key] {
                merged[key] = existingSector.merging(deltaSector)
            } else {
                merged[key] = deltaSector
            }
        }

        return .dictionary(merged)
    }

    var dictionary: [String: BestSector] {
        switch self {
        case .array(let array):
            Dictionary(uniqueKeysWithValues: array.enumerated().map { (String($0.offset), $0.element) })
        case .dictionary(let dictionary):
            dictionary
        }
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

extension BestSector {
    func merging(_ delta: BestSector?) -> BestSector {
        guard let delta else { return self }

        return BestSector(
            value: delta.value ?? value,
            position: delta.position ?? position
        )
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

extension BestSpeeds {
    func merging(_ delta: BestSpeeds?) -> BestSpeeds {
        guard let delta else { return self }

        return BestSpeeds(
            i1: i1?.merging(delta.i1) ?? delta.i1,
            i2: i2?.merging(delta.i2) ?? delta.i2,
            fl: fl?.merging(delta.fl) ?? delta.fl,
            st: st?.merging(delta.st) ?? delta.st
        )
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

extension PersonalBestLapTime {
    func merging(_ delta: PersonalBestLapTime?) -> PersonalBestLapTime {
        guard let delta else { return self }

        return PersonalBestLapTime(
            value: delta.value ?? value,
            lap: delta.lap ?? lap,
            position: delta.position ?? position
        )
    }
}
