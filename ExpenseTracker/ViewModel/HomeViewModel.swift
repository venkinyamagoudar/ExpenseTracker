//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import Foundation
import SwiftUI
import CoreData

class HomeViewModel: ObservableObject {
   
    @Published var selectedSortingCriteria: SortingCriteria = .date
    @Published var isShowingAddView = false
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    @FetchRequest(
        entity: ExpenseItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.date, ascending: false)],
        animation: .default
    ) private var sortByDateItems: FetchedResults<ExpenseItem>
    
    @FetchRequest(
        entity: ExpenseItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.title, ascending: true)],
        animation: .default
    ) private var sortByTitleItems: FetchedResults<ExpenseItem>
    
    @FetchRequest(
        entity: ExpenseItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.amount, ascending: false)],
        animation: .default
    ) private var sortByAmountItems: FetchedResults<ExpenseItem>
    
    var items: FetchedResults<ExpenseItem> {
        switch selectedSortingCriteria {
        case .amount:
            return sortByAmountItems
        case .title:
            return sortByTitleItems
        case .date:
            return sortByDateItems
        }
    }
    
    var hasItems: Bool {
        return !items.isEmpty
    }
    
    var totalAmount: String {
        return getTotalAmount()
    }
    
    var spendingAmount: String {
        return getTotalSpendingAmount()
    }
    
    var recivedAmount: String {
        return getTotalReceivingAmount()
    }
    
    private func getTotalSpendingAmount() -> String {
        let spendingItems = items.filter { $0.type == "Spending" }
        let totalSpending = spendingItems.reduce(0) { $0 + $1.amount }
        return String(format: "%.2f", totalSpending)
    }
    
    private func getTotalReceivingAmount() -> String {
        let ReceivingItems = items.filter { $0.type == "Receiving" }
        let totalReceiving = ReceivingItems.reduce(0) { $0 + $1.amount }
        return String(format: "%.2f", totalReceiving)
    }
    
    private func getTotalAmount() -> String {
        guard let spendingAmount = Double(spendingAmount),
              let receivingAmount = Double(recivedAmount) else {
            return "Error"
        }
        
        let difference = receivingAmount - spendingAmount
        return String(format: "%.2f", difference)
    }
    
    func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            managedObjectContext.delete(item)
        }
        saveItems()
    }
    
    private func saveItems() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
