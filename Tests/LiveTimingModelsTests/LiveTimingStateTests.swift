import Testing
@testable import LiveTimingModels

@Suite("LiveTimingState")
struct LiveTimingStateTests {

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
}
