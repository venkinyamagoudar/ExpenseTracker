//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

struct ExpenseTabView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @State var selectedTab = 0
    
    var body: some View {
        
        TabView {
            NavigationView {
                HomeView()
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(0)

            NavigationView {
                ActivityView()
                    .environment(\.managedObjectContext, managedObjectContext)
            }
            .tabItem {
                Image(systemName: "chart.bar.xaxis")
                Text("Activity")
            }
            .tag(2)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

struct ExpenseTabView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTabView()
    }
}
