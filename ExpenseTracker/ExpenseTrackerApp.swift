//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ExpenseTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
