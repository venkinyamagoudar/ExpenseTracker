//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

struct AmountTypeView: View {
    var amount: String
    var type: TypeOfAmount
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(type == .spending ? "Spending": "Receiving")
                    .font(.headline)
                Text(amount)
                    .font(Font.body)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: type == .spending ? "arrow.up" : "arrow.down")
                .frame(width: 30,height: 30)
                .background(type == .spending ? .red : .green)
                .cornerRadius(15)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .foregroundColor(.primary)
        .cornerRadius(10)
    }
}

struct SpendingView_Previews: PreviewProvider {
    static var previews: some View {
        AmountTypeView(amount: "0.0", type: .spending)
    }
}

