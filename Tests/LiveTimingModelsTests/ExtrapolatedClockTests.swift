import Foundation
import Testing
@testable import LiveTimingModels

@Suite("ExtrapolatedClock")
struct ExtrapolatedClockTests {

    @Test("ExtrapolatedClock decodes feed utc")
    func extrapolatedClockDecodesFeedUTC() throws {
        let clock = try JSONDecoder().decode(
            ExtrapolatedClock.self,
            from: Data(#"{"Utc":"2026-03-07T05:00:01.007Z","Remaining":"00:17:59","Extrapolating":true}"#.utf8)
        )

        #expect(clock.hasUtc)
        #expect(clock.remaining == "00:17:59")
        #expect(clock.extrapolating == true)
        #expect(abs(clock.utc.timeIntervalSince1970 - 1_772_859_601.007) < 0.001)
    }

    @Test("ExtrapolatedClock merge preserves missing sparse fields")
    func extrapolatedClockMergePreservesMissingSparseFields() {
        var clock = ExtrapolatedClock(
            utc: Date(timeIntervalSince1970: 1_772_859_601.007),
            remaining: "00:17:59",
            extrapolating: true,
            hasUtc: true
        )

        clock.merge(with: ExtrapolatedClock(remaining: "00:17:58", extrapolating: nil))

        #expect(clock.hasUtc)
        #expect(abs(clock.utc.timeIntervalSince1970 - 1_772_859_601.007) < 0.001)
        #expect(clock.remaining == "00:17:58")
        #expect(clock.extrapolating == true)
    }
}
