//
//
//
// Created by: Patrik Drab on 26/04/2025
// Copyright (c) 2025 MHD 
//
//         





//        let icon_light = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .large),
//            tintColor: .black
//        )
//
//        let icon_medium = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large),
//            tintColor: .black
//        )
//
//        let icon_regular = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large),
//            tintColor: .black
//        )
//
//        let icon_semibold = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .large),
//            tintColor: .black
//        )
//
//        let icon_bold = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large),
//            tintColor: .black
//        )
//
//        let icon_heavy = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .heavy, scale: .large),
//            tintColor: .black
//        )
//
//        let icon_black = IconImageView(
//            systemName: "house",
//            config: UIImage.SymbolConfiguration(pointSize: 24, weight: .black, scale: .large),
//            tintColor: .black
//        )
//
//        let iconsView = UIStackView(
//            arrangedSubviews: [
//                icon_light,
//                icon_regular,
//                icon_medium,
//                icon_semibold,
//                icon_bold,
//                icon_heavy,
//                icon_black
//            ],
//            axis: .horizontal,
//            spacing: 10,
//            alignment: .center,
//            distribution: .fill
//        )





//
//struct TransitSchedule: Hashable, Identifiable {
//    let id: String
//    let dailySchedules: [DailySchedule]
//
//    func schedule(for dayType: DayType) -> DailySchedule? {
//        dailySchedules.first { $0.dayTypes.contains(dayType) }
//    }
//}
//
//struct DailySchedule: Hashable {
//    let dayTypes: Set<DayType>
//    let hourlyDepartures: [HourlyDeparture]
//}
//
//
////
////extension TransitSchedule {
//    static func generateDummyData() -> TransitSchedule {
//        let workingSchoolDay = generateDailySchedule(for: .workingSchoolDay)
//        let workingHoliday = generateDailySchedule(for: .workingHoliday)
//        let weekendHoliday = generateDailySchedule(for: .weekendOrHoliday)
//
//        return TransitSchedule(
//            id: "bus_n_4-march_2025",
//            dayTypeSchedule: [workingSchoolDay, workingHoliday, weekendHoliday]
//        )
//    }
//
//    private static func generateDailySchedule(for dayType: DayType) -> DayTypeSchedule {
//        let hours = 5...22 // From 5:00 to 22:00
//        var departures = [HourlyDeparture]()
//
//        for hour in hours {
//            // Generate minutes with normal distribution pattern
//            let minutes = generateMinutesForHour(hour, dayType: dayType)
//            departures.append(HourlyDeparture(
//                hour: hour,
//                minutes: minutes.map { MinuteInfo(minute: $0, condition: randomCondition()) }
//            ))
//        }
//
//        return DayTypeSchedule(
//            dayType: dayType,
//            hourlyDepartures: departures
//        )
//    }
//
//    private static func generateMinutesForHour(_ hour: Int, dayType: DayType) -> [Int] {
//        // Base frequency (more departures during rush hours)
//        var count: Int
//        switch dayType {
//        case .workingSchoolDay:
//            count = rushHourMultiplier(hour) * Int.random(in: 1...6)
//        case .workingHoliday:
//            count = rushHourMultiplier(hour) * Int.random(in: 1...2)
//        case .weekendOrHoliday:
//            count = Int.random(in: 1...2)
//        }
//
//        // Generate minutes with normal distribution
//        var minutes = Set<Int>()
//        while minutes.count < count {
//            let minute = generateNormallyDistributedMinute(for: hour)
//            if minute >= 0 && minute < 60 {
//                minutes.insert(minute)
//            }
//        }
//
//        return Array(minutes).sorted()
//    }
//
//    private static func rushHourMultiplier(_ hour: Int) -> Int {
//        switch hour {
//        case 7...9, 15...18: // Morning and afternoon rush hours
//            return 1
//        default:
//            return 1
//        }
//    }
//
//    private static func generateNormallyDistributedMinute(for hour: Int) -> Int {
//        let baseMinutes = [0, 15, 30, 45]
//        let base = baseMinutes.randomElement()!
//        let stdDev = 4.0 // Standard deviation (minutes)
//        let normalValue = Int(round(Double.random(in: -2.0...2.0) * stdDev))
//        return base + normalValue
//    }
//
//    private static func randomCondition() -> Character? {
//        let conditions: [Character?] = ["D", "E", "C", nil, nil, nil, nil] // 3/7 chance of having condition
//        return conditions.randomElement()!
//    }
//}
