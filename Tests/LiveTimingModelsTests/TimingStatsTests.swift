import Foundation
import Testing
@testable import LiveTimingModels

@Suite("TimingStats")
struct TimingStatsTests {

    @Test("TimingStats merge preserves sparse line metadata")
    func timingStatsMergePreservesSparseLineMetadata() throws {
        var base = try decodeTimingStats("""
        {
          "Lines": {
            "1": {
              "Line": 1,
              "RacingNumber": "1",
              "PersonalBestLapTime": {
                "Value": "1:14.123",
                "Lap": 4,
                "Position": 2
              },
              "BestSectors": {
                "0": {
                  "Value": "28.123",
                  "Position": 2
                }
              },
              "BestSpeeds": {
                "I1": {
                  "Value": "197",
                  "Position": 2
                },
                "I2": {
                  "Value": "289",
                  "Position": 3
                }
              }
            }
          }
        }
        """)
        let delta = try decodeTimingStats("""
        {
          "Lines": {
            "1": {
              "BestSpeeds": {
                "I1": {
                  "Value": "198",
                  "Position": 1
                }
              }
            }
          }
        }
        """)

        base.merge(with: delta)

        let line = try #require(base.lines["1"])
        #expect(line.line == 1)
        #expect(line.racingNumber == "1")
        #expect(line.personalBestLapTime?.value == "1:14.123")
        #expect(line.personalBestLapTime?.lap == 4)
        #expect(line.personalBestLapTime?.position == 2)
        #expect(line.bestSpeeds?.i1?.value == "198")
        #expect(line.bestSpeeds?.i1?.position == 1)
        #expect(line.bestSpeeds?.i2?.value == "289")
        #expect(line.bestSpeeds?.i2?.position == 3)
    }

    @Test("TimingStats merge preserves sparse best sector updates")
    func timingStatsMergePreservesSparseBestSectorUpdates() throws {
        var base = try decodeTimingStats("""
        {
          "Lines": {
            "1": {
              "BestSectors": {
                "0": {
                  "Value": "28.123",
                  "Position": 2
                },
                "1": {
                  "Value": "31.456",
                  "Position": 3
                }
              }
            }
          }
        }
        """)
        let delta = try decodeTimingStats("""
        {
          "Lines": {
            "1": {
              "BestSectors": {
                "0": {
                  "Position": 1
                }
              }
            }
          }
        }
        """)

        base.merge(with: delta)

        guard case .dictionary(let sectors)? = base.lines["1"]?.bestSectors else {
            Issue.record("Expected merged dictionary best sectors")
            return
        }

        #expect(sectors["0"]?.value == "28.123")
        #expect(sectors["0"]?.position == 1)
        #expect(sectors["1"]?.value == "31.456")
        #expect(sectors["1"]?.position == 3)
    }
}

private func decodeTimingStats(_ json: String) throws -> TimingStats {
    try JSONDecoder().decode(TimingStats.self, from: Data(json.utf8))
}
