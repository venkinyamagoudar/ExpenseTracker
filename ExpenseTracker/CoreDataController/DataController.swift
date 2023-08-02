//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "ExpensesModel")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error while loading Core data. \(error.localizedDescription)")
            }
        }
    }
}

//class DataController: ObservableObject {
//    let container: NSPersistentContainer
//    
//    init() {
//        container = NSPersistentContainer(name: "ExpensesModel")
//        loadPersistentStores()
//    }
//    
//    private func loadPersistentStores() {
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("Error while loading Core Data. \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func saveContext() {
//        let context = container.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    func deleteExpense(_ item: ExpenseItem) {
//        container.viewContext.delete(item)
//        saveContext()
//    }
//
//    func fetchSortedExpenses(by sortingCriteria: SortingCriteria) -> [ExpenseItem] {
//        let sortDescriptor: NSSortDescriptor
//        switch sortingCriteria {
//        case .date:
//            sortDescriptor = NSSortDescriptor(keyPath: \ExpenseItem.date, ascending: false)
//        case .title:
//            sortDescriptor = NSSortDescriptor(keyPath: \ExpenseItem.title, ascending: true)
//        case .amount:
//            sortDescriptor = NSSortDescriptor(keyPath: \ExpenseItem.amount, ascending: false)
//        }
//
//        let fetchRequest: NSFetchRequest<ExpenseItem> = ExpenseItem.fetchRequest()
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            return try container.viewContext.fetch(fetchRequest)
//        } catch {
//            print("Error fetching expenses: \(error)")
//            return []
//        }
//    }
//
//    func fetchExpensesFromLastDays(_ days: Int) -> [ExpenseItem] {
//        let calendar = Calendar.current
//        guard let fromDate = calendar.date(byAdding: .day, value: -days, to: Date()) else {
//            return []
//        }
//
//        let fetchRequest: NSFetchRequest<ExpenseItem> = ExpenseItem.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "date >= %@", fromDate as NSDate)
//
//        do {
//            return try container.viewContext.fetch(fetchRequest)
//        } catch {
//            print("Error fetching expenses: \(error)")
//            return []
//        }
//    }
//}
