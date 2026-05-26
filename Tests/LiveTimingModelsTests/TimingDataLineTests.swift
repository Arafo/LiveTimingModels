import Testing
@testable import LiveTimingModels

@Suite("TimingDataLine")
struct TimingDataLineTests {

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
