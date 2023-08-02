//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI
import CoreData

struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: ExpenseItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.date, ascending: true)]) var totalItems: FetchedResults<ExpenseItem>
    
    @State private var expensesLastSevenDays: [ExpenseItem] = []
    @State private var expensesLastThirtyDays: [ExpenseItem] = []
    @State private var selectedIndex = 0
    
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
    
    var body: some View {
        VStack {
            Picker(selection: $selectedIndex, label: Text("Activity Period")) {
                Text("Last 7 Days").tag(0)
                Text("Last 30 Days").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            GeometryReader { geometry in // Use GeometryReader to get the available view height
                VStack {
                    if selectedIndex == 0 {
                        if hasExpensesLastSevenDays {
                            BarChartActivityView(data: expensesLastSevenDays, title: "Last 7 Days Activity", height: geometry.size.height * 0.7)
                        } else {
                            AddLottieView(lottieFileName: LottieFiles.noDataFound)
                        }
                    } else {
                        if hasItems {
                            BarChartActivityView(data: expensesLastThirtyDays, title: "Previous 30 Days Activity", height: geometry.size.height * 0.7)
                        } else {
                            AddLottieView(lottieFileName: LottieFiles.noDataFound)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadActivityData()
        }
        .navigationTitle("Activity")
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
