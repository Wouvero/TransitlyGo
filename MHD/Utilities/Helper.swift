//
//
//
// Created by: Patrik Drab on 03/05/2025
// Copyright (c) 2025 MHD
//
//

import Foundation


func numberToString<T: Numeric>(_ num: T) -> String {
    return "\(num)"
}


func formatMinute(_ minuteInfo: MHD_MinuteInfo) -> String {
    let formattedMinute = String(format: "%02d", minuteInfo.minute)
    if let condition = minuteInfo.condition {
        return "\(formattedMinute) \(condition.uppercased())"
    }
    return formattedMinute
}





func isHoliday(date: Date, calendar: Calendar) -> Bool {
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    guard let year = components.year, let month = components.month, let day = components.day else {
        return false
    }
    
    let fixedHolidays: [(month: Int, day: Int)] = [
        (1, 1),   // Nový Rok
        (1, 6),   // Zjavenie Pána (Traja králi)
        (5, 1),   // Sviatok práce
        (5, 8),   // Deň víťazstva nad fašizmom
        (7, 5),   // Sviatok svätého Cyrila a Metoda
        (8, 29),  // Výročie SNP
        (9, 1),   // Deň Ústavy SR
        (9, 15),  // Sedembolestná Panna Mária
        (11, 1),  // Sviatok všetkých svätých
        (11, 17), // Deň boja za slobodu a demokraciu
        (12, 24), // Štedrý deň
        (12, 25), // Prvý sviatok vianočný
        (12, 26)  // Druhý sviatok vianočný
    ]
    
    if fixedHolidays.contains(where: { $0.month == month && $0.day == day }) {
        return true
    }
    
    // Movable holidays (Easter-based)
    let easterDate = calculateEaster(year: year)
    //let easterComponents = calendar.dateComponents([.month, .day], from: easterDate)
    
    // Good Friday (2 days before Easter)
    if let goodFriday = calendar.date(byAdding: .day, value: -2, to: easterDate),
       calendar.isDate(date, equalTo: goodFriday, toGranularity: .day) {
        return true
    }
    
    // Easter Monday (1 day after Easter)
    if let easterMonday = calendar.date(byAdding: .day, value: 1, to: easterDate),
       calendar.isDate(date, equalTo: easterMonday, toGranularity: .day) {
        return true
    }
    
    return false
}

func isSchoolHoliday(date: Date, calendar: Calendar) -> Bool {
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    guard let year = components.year, let month = components.month /*let day = components.day*/ else {
        return false
    }
    
    // Summer vacation (July 1 - August 31)
    if month == 7 || month == 8 {
        return true
    }
    
    // Other vacations (dates may vary slightly by year)
    let autumnVacation: DateInterval = {
        let start = dateFor(day: 30, month: 10, year: year)!
        let end = dateFor(day: 3, month: 11, year: year)!
        return DateInterval(start: start, end: end)
    }()
    
    let christmasVacation: DateInterval = {
        let start = dateFor(day: 23, month: 12, year: year)!
        let end = dateFor(day: 7, month: 1, year: year + 1)!
        return DateInterval(start: start, end: end)
    }()
    
    let springVacation: DateInterval = {
        let start = dateFor(day: 4, month: 2, year: year)!
        let end = dateFor(day: 10, month: 2, year: year)!
        return DateInterval(start: start, end: end)
    }()
    
    let easterVacation: DateInterval = {
        let easter = calculateEaster(year: year)
        let start = calendar.date(byAdding: .day, value: -3, to: easter)!
        let end = calendar.date(byAdding: .day, value: 2, to: easter)!
        return DateInterval(start: start, end: end)
    }()
    
    if springVacation.contains(date) || easterVacation.contains(date) || autumnVacation.contains(date) || christmasVacation.contains(date) {
        return true
    }
    
    
    return false
}

// Calculate Easter date (Gregorian calendar)
func calculateEaster(year: Int) -> Date {
    // Anonymous Gregorian algorithm
    let a = year % 19
    let b = year / 100
    let c = year % 100
    let d = b / 4
    let e = b % 4
    let f = (b + 8) / 25
    let g = (b - f + 1) / 3
    let h = (19 * a + b - d - g + 15) % 30
    let i = c / 4
    let k = c % 4
    let l = (32 + 2 * e + 2 * i - h - k) % 7
    let m = (a + 11 * h + 22 * l) / 451
    let month = (h + l - 7 * m + 114) / 31
    let day = ((h + l - 7 * m + 114) % 31) + 1
    
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components)!
}

func dateFor(day: Int, month: Int, year: Int) -> Date? {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components)
}
