//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

struct AmountModifier: ViewModifier {
    var item: ExpenseItem
    
    func body(content: Content) -> some View {
        switch item.type {
            
        case "Spending" :
            content
                .foregroundColor(.red)
        case "Receiving" :
            content
                .foregroundColor(.green)
        default:
            content
                .foregroundColor(.yellow)
        }
    }
}

extension View {
    func amountModifier(for item: ExpenseItem) -> some View {
        modifier(AmountModifier(item: item))
    }
}
