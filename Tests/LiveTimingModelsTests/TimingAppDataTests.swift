import Foundation
import Testing
@testable import LiveTimingModels

@Suite("TimingAppData")
struct TimingAppDataTests {

    @Test("TimingAppData merge preserves sparse stint metadata")
    func timingAppDataMergePreservesSparseStintMetadata() throws {
        var base = try decodeTimingAppData("""
        {
          "Lines": {
            "1": {
              "Line": 1,
              "Stints": {
                "2": {
                  "Compound": "HARD",
                  "New": "false",
                  "TyresNotChanged": "1",
                  "TotalLaps": 9,
                  "StartLaps": 3
                }
              }
            }
          }
        }
        """)
        let delta = try decodeTimingAppData("""
        {
          "Lines": {
            "1": {
              "Stints": {
                "2": {
                  "TotalLaps": 13
                }
              }
            }
          }
        }
        """)

        base.merge(with: delta)

        guard case .dictionary(let stints)? = base.lines["1"]?.stints,
              let stint = stints["2"] else {
            Issue.record("Expected merged dictionary stint")
            return
        }

        #expect(stint.compound == .hard)
        #expect(stint.new == "false")
        #expect(stint.tyresNotChanged == "1")
        #expect(stint.totalLaps == 13)
        #expect(stint.startLaps == 3)
    }
}

private func decodeTimingAppData(_ json: String) throws -> TimingAppData {
    try JSONDecoder().decode(TimingAppData.self, from: Data(json.utf8))
}
