//
//
//
// Created by: Patrik Drab on 22/06/2025
// Copyright (c) 2025 MHD 
//
//         



enum DayType: Int, Encodable, Hashable {
    case workingSchoolDay = 0
    case workingHoliday = 1
    case weekendOrHoliday = 2
    
    var description: String {
        switch self {
        case .workingSchoolDay: return "Pracovný školský deň"
        case .workingHoliday: return "Pracovný prázdninový deň"
        case .weekendOrHoliday: return "Sobota, Nedeľa, Sviatok"
        }
    }
}