import Foundation

public struct TimingAppData: Codable, Sendable {
    public var lines: [String: TimingAppDataLine]

    public init(lines: [String: TimingAppDataLine] = [:]) {
        self.lines = lines
    }

    enum CodingKeys: String, CodingKey {
        case lines = "Lines"
    }
}

extension TimingAppData {
    public static var empty: Self {
        .init(lines: [:])
    }
}

extension TimingAppData {
    public mutating func merge(with delta: TimingAppData) {
        for (car, newLine) in delta.lines {
            if var existing = lines[car] {
                existing.merge(with: newLine)
                lines[car] = existing
            } else {
                lines[car] = newLine
            }
        }
    }
}

extension TimingAppDataLine {
    mutating func merge(with delta: TimingAppDataLine) {
        if let racingNumber = delta.racingNumber { self.racingNumber = racingNumber }
        if let line = delta.line { self.line = line }
        if let gridPos = delta.gridPos { self.gridPos = gridPos }
        if let deltaStints = delta.stints {
            if var existingStints = stints {
                existingStints.merge(with: deltaStints)
                stints = existingStints
            } else {
                stints = deltaStints
            }
        }
    }
}

extension TimingAppDataLineStint {
    mutating func merge(with delta: TimingAppDataLineStint) {
        var merged = dictionary
        for (key, deltaStint) in delta.dictionary {
            if let existingStint = merged[key] {
                merged[key] = existingStint.merging(deltaStint)
            } else {
                merged[key] = deltaStint
            }
        }

        self = .dictionary(merged)
    }

    var dictionary: [String: LineStint] {
        switch self {
        case .array(let array):
            return Dictionary(uniqueKeysWithValues: array.enumerated().map { (String($0.offset), $0.element) })
        case .dictionary(let dictionary):
            return dictionary
        }
    }
}

extension LineStint {
    func merging(_ delta: LineStint) -> LineStint {
        LineStint(
            lapFlags: delta.lapFlags ?? lapFlags,
            compound: delta.compound ?? compound,
            new: delta.new ?? new,
            tyresNotChanged: delta.tyresNotChanged ?? tyresNotChanged,
            totalLaps: delta.totalLaps ?? totalLaps,
            startLaps: delta.startLaps ?? startLaps,
            lapTime: delta.lapTime ?? lapTime,
            lapNumber: delta.lapNumber ?? lapNumber
        )
    }
}

public struct TimingAppDataLine: Codable, Sendable {
    public var racingNumber: String?
    public var line: Int?
    public var gridPos: String?
    public var stints: TimingAppDataLineStint?

    enum CodingKeys: String, CodingKey {
        case racingNumber = "RacingNumber"
        case line = "Line"
        case gridPos = "GridPos"
        case stints = "Stints"
    }
}

public enum TimingAppDataLineStint: Codable, Sendable {
    case array([LineStint])
    case dictionary([String: LineStint])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let arr = try? container.decode([LineStint].self) {
            self = .array(arr)
            return
        }

        if let dict = try? container.decode([String: LineStint].self) {
            self = .dictionary(dict)
            return
        }

        if container.decodeNil() {
            self = .array([])
            return
        }

        throw DecodingError.typeMismatch(
            TimingAppDataLineStint.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected array or dictionary for TimingAppDataLineStint"
            )
        )
    }
}
