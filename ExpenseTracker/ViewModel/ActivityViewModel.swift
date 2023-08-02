//
//  ActivityViewModel.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import CoreData

class ActivityViewModel: ObservableObject {
    @Published var selectedIndex = 0
    @Published var expensesLastSevenDays: [ExpenseItem] = []
    @Published var expensesLastThirtyDays: [ExpenseItem] = []
    private var totalItems: [ExpenseItem] = []

    private var dataController: DataController

    init(dataController: DataController) {
        self.dataController = dataController
    }

    fileprivate func loadActivityData() {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()

        let sevenDaysPredicate = NSPredicate(format: "date >= %@", sevenDaysAgo as NSDate)
        let thirtyDaysPredicate = NSPredicate(format: "date >= %@", thirtyDaysAgo as NSDate)

        let sevenDaysItems = totalItems.filter { sevenDaysPredicate.evaluate(with: $0) }
        let thirtyDaysItems = totalItems.filter { thirtyDaysPredicate.evaluate(with: $0) }

        expensesLastSevenDays = Array(sevenDaysItems)
        expensesLastThirtyDays = Array(thirtyDaysItems)
    }

    private var hasItems: Bool {
        return !totalItems.isEmpty
    }

    private var hasExpensesLastSevenDays: Bool {
        return !expensesLastSevenDays.isEmpty
    }

    private var hasExpensesLastThirtyDays: Bool {
        return !expensesLastThirtyDays.isEmpty
    }

    func fetchTotalItems() {
//        totalItems = dataController.fetchAllExpenses()
        loadActivityData()
    }
}
