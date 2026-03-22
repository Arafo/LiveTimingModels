import Foundation

public enum StringDecodingError: Error {
    case unableToEncode(String, encoding: String.Encoding)
}

extension StringDecodingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unableToEncode(string, encoding):
            return "Unable to encode \(string) using encoding \(encoding)."
        }
    }
}

struct AnyCodableWrapper: Codable {
    let dictionary: [String: AnyCodable]
}

extension AnyCodable {
    /// Converts the underlying value to a typed `Decodable` model.
    ///
    /// Uses `JSONSerialization` instead of `JSONEncoder` to avoid a Swift 6
    /// concurrency issue: after decoding, nested containers are stored as
    /// `[String: Any]` / `[Any]` which cannot be cast to `[String: Sendable?]`
    /// / `[Sendable?]` in `_AnyEncodable.encode(to:)`, causing silent encoding
    /// failures for every payload with nested objects.
    func to<T: Decodable>(
        _ type: T.Type,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
    ) throws -> T {
        let sanitized = Self.sanitize(value)
        let data = try JSONSerialization.data(withJSONObject: sanitized, options: .fragmentsAllowed)
        return try decoder.decode(T.self, from: data)
    }

    /// Recursively converts `AnyCodable` value tree into types that
    /// `JSONSerialization` can handle. Fixes:
    /// - `Void` / `()` (AnyCodable's nil representation) → `NSNull`
    /// - `UInt` → `Int`
    /// - Nested `[Any]` / `[String: Any]` → recursed
    static func sanitize(_ value: Any) -> Any {
        switch value {
        case is Void:
            return NSNull()
        case let bool as Bool:
            return bool
        case let uint as UInt:
            return Int(uint)
        case let int as Int:
            return int
        case let double as Double:
            return double
        case let string as String:
            return string
        case let array as [Any]:
            return array.map { sanitize($0) }
        case let dict as [String: Any]:
            return dict.mapValues { sanitize($0) }
        default:
            return "\(value)"
        }
    }
}

extension Dictionary where Key == String, Value == AnyCodable {
    public func to<T: Decodable>(
        _ type: T.Type,
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) throws -> T {
        let wrapper = AnyCodableWrapper(dictionary: self)
        let data = try encoder.encode(wrapper.dictionary)
        return try decoder.decode(type, from: data)
    }
}

extension String {
    public func to<T: Decodable>(
        _ type: T.Type,
        decoder: JSONDecoder,
        encoding: String.Encoding = .utf8
    ) throws -> T {
        guard let data = self.data(using: encoding) else {
            throw StringDecodingError.unableToEncode(self, encoding: encoding)
        }
        return try decoder.decode(type, from: data)
    }
}
