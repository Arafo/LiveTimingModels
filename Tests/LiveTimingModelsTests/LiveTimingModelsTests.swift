import Foundation
import Testing
@testable import LiveTimingModels

@Suite("LiveTimingModels")
struct LiveTimingModelsTests {

    @Test("LiveTimingState default initializer produces nil optional fields")
    func liveTimingStateEmpty() {
        let state = LiveTimingState()
        #expect(state.topThree == nil)
        #expect(state.trackStatus == nil)
        #expect(state.raceControlMessages == nil)
        #expect(state.sessionInfo == nil)
        #expect(state.sessionData == nil)
        #expect(state.teamRadio == nil)
        #expect(state.tyreStintSeries == nil)
        #expect(state.championshipPrediction == nil)
        #expect(state.pitStopSeries == nil)
        #expect(state.pitLaneTimeCollection == nil)
    }

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

    @Test("TimingDataLine merge applies delta fields")
    func timingDataLineMerge() {
        var base = TimingDataLine(position: "1", racingNumber: "1", sectors: [:])
        let delta = TimingDataLine(gapToLeader: "+1.234", position: "2", sectors: [:])

        base.merge(with: delta)

        #expect(base.position == "2")
        #expect(base.gapToLeader == "+1.234")
        #expect(base.racingNumber == "1") // unchanged from base
    }
}
