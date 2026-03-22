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
                if let v = newLine.racingNumber { existing.racingNumber = v }
                if let v = newLine.line { existing.line = v }
                if let v = newLine.gridPos { existing.gridPos = v }
                if let v = newLine.stints { existing.stints = v }
                lines[car] = existing
            } else {
                lines[car] = newLine
            }
        }
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
