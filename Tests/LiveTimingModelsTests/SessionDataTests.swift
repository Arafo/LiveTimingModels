import Foundation
import Testing
@testable import LiveTimingModels

@Suite("SessionData")
struct SessionDataTests {

    @Test("Series keeps the qualifying part so clients can show Q1, Q2 or Q3")
    func seriesDecodesQualifyingPart() throws {
        let json = """
        {
            "Series": {
                "0": { "Utc": "2025-10-18T20:46:52.227Z", "QualifyingPart": 0 },
                "1": { "Utc": "2025-10-18T20:46:53.633Z", "QualifyingPart": 1 },
                "2": { "Utc": "2025-10-18T21:34:00.459Z", "QualifyingPart": 2 }
            }
        }
        """.data(using: .utf8)!

        let sessionData = try JSONDecoder().decode(SessionData.self, from: json)

        #expect(sessionData.series.map(\.qualifyingPart) == [0, 1, 2])
    }

    @Test("Race series carry laps and no qualifying part")
    func raceSeriesHasNoQualifyingPart() throws {
        let json = """
        { "Series": [{ "Utc": "2025-08-03T13:03:00Z", "Lap": 1 }] }
        """.data(using: .utf8)!

        let series = try #require(try JSONDecoder().decode(SessionData.self, from: json).series.first)

        #expect(series.lap == 1)
        #expect(series.qualifyingPart == nil)
    }
}
