//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import Foundation

//MARK: TypeOfAmount

enum TypeOfAmount: String, Equatable {
    case spending = "Spending"
    case receiving = "Receiving"
}

//MARK: SortingCriteria

enum SortingCriteria: String, CaseIterable, Identifiable {
    case date
    case title
    case amount
    var id: SortingCriteria { self }
}
