//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import Foundation

extension Date {
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }
    
    func previousSevenDaysDates() -> [String] {
        var dates: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        for day in 1...7 {
            if let previousDate = Calendar.current.date(byAdding: .day, value: -day, to: self) {
                let dateString = previousDate.toString(dateStyle: .short, timeStyle: .none)
                dates.append(dateString)
            }
        }
        
        return dates
    }
}
