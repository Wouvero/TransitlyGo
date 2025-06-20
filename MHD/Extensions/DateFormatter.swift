//
//
//
// Created by: Patrik Drab on 18/06/2025
// Copyright (c) 2025 MHD 
//
//         
import Foundation

// Special date formatting with Slovak labels
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "sk_SK") // Slovak locale
    
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let targetDate = calendar.startOfDay(for: date)
    
    if today == targetDate {
        formatter.dateFormat = "(EEEE)"
        return "dnes " + formatter.string(from: date)
    } else if calendar.date(byAdding: .day, value: 1, to: today) == targetDate {
        formatter.dateFormat = "(EEEE)"
        return "zajtra " + formatter.string(from: date)
    } else if calendar.date(byAdding: .day, value: 2, to: today) == targetDate {
        formatter.dateFormat = "(EEEE)"
        return "pozajtra " + formatter.string(from: date)
    } else {
        formatter.dateFormat = "dd.MM. (EEEE)"
        return formatter.string(from: date)
    }
}
