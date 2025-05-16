//
//
//
// Created by: Patrik Drab on 13/05/2025
// Copyright (c) 2025 MHD 
//
//         

import Foundation

extension TimeInterval {
    func formattedTimeRemaining() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        if self >= 86400 {
            formatter.allowedUnits = [.day, .hour, .minute, .second]
        }
        else if self >= 3600 {
            formatter.allowedUnits = [.hour, .minute, .second]
        }
        else {
            formatter.allowedUnits = [.minute, .second]
        }
        
        return formatter.string(from: self) ?? "0:00"
    }
}

