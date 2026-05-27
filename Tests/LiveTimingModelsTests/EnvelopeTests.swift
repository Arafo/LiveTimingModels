import Foundation
import Testing
@testable import LiveTimingModels

@Suite("Envelope")
struct EnvelopeTests {

    @Test("Envelope decodes from minimal JSON")
    func envelopeDecode() throws {
        let json = """
        {
            "Heartbeat": { "Utc": "2025-03-22T14:00:00Z" }
        }
        """.data(using: .utf8)!

        let envelope = try JSONDecoder().decode(Envelope.self, from: json)
        #expect(envelope.heartbeat != nil)
        #expect(envelope.timingData == nil)
        #expect(envelope.driverList == nil)
    }
}
