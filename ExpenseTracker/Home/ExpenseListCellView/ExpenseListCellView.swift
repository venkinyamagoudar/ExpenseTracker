//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

struct ExpenseListCellView: View {
    var item: ExpenseItem
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(item.title!)
                    .font(.headline)
                    .lineLimit(1)
                Text(item.type!)
                    .font(.subheadline)
            }
            Spacer()
            VStack{
                Text(item.amount, format: .localCurrency)
                    .amountModifier(for: item)
                    .lineLimit(1)
                Text((item.date?.toString(dateStyle: .short, timeStyle: .none))!)
            }
        }
    }
}
