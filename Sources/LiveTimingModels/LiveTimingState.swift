import Foundation

public struct LiveTimingState: Codable, Sendable {
    public init(
        heartbeat: Heartbeat = .empty,
        extrapolatedClock: ExtrapolatedClock = .empty,
        topThree: TopThree? = nil,
        timingStats: TimingStats = .empty,
        timingAppData: TimingAppData = .empty,
        weatherData: WeatherData = .empty,
        trackStatus: TrackStatus? = nil,
        driverList: DriverList = .empty,
        raceControlMessages: RaceControlMessages? = nil,
        sessionInfo: SessionInfo? = nil,
        sessionData: SessionData? = nil,
        lapCount: LapCount = .empty,
        timingData: TimingData = .empty,
        teamRadio: TeamRadio? = nil,
        tyreStintSeries: TyreStintSeries? = nil,
        championshipPrediction: ChampionshipPrediction? = nil,
        pitStopSeries: PitStopSeries? = nil,
        pitLaneTimeCollection: PitLaneTimeCollection? = nil,
        carData: CarData = .empty,
        positionZ: PositionZ = .empty
    ) {
        self.heartbeat = heartbeat
        self.extrapolatedClock = extrapolatedClock
        self.topThree = topThree
        self.timingStats = timingStats
        self.timingAppData = timingAppData
        self.weatherData = weatherData
        self.trackStatus = trackStatus
        self.driverList = driverList
        self.raceControlMessages = raceControlMessages
        self.sessionInfo = sessionInfo
        self.sessionData = sessionData
        self.lapCount = lapCount
        self.timingData = timingData
        self.teamRadio = teamRadio
        self.tyreStintSeries = tyreStintSeries
        self.championshipPrediction = championshipPrediction
        self.pitStopSeries = pitStopSeries
        self.pitLaneTimeCollection = pitLaneTimeCollection
        self.carData = carData
        self.positionZ = positionZ
    }

    public var heartbeat: Heartbeat = .empty
    public var extrapolatedClock: ExtrapolatedClock = .empty
    public var topThree: TopThree?
    public var timingStats: TimingStats = .empty
    public var timingAppData: TimingAppData = .empty
    public var weatherData: WeatherData = .empty
    public var trackStatus: TrackStatus?
    public var driverList: DriverList = .empty
    public var raceControlMessages: RaceControlMessages?
    public var sessionInfo: SessionInfo?
    public var sessionData: SessionData?
    public var lapCount: LapCount = .empty
    public var timingData: TimingData = .empty
    public var teamRadio: TeamRadio?
    public var tyreStintSeries: TyreStintSeries?
    public var championshipPrediction: ChampionshipPrediction?
    public var pitStopSeries: PitStopSeries?
    public var pitLaneTimeCollection: PitLaneTimeCollection?
    public var carData: CarData = .empty
    public var positionZ: PositionZ = .empty
}
