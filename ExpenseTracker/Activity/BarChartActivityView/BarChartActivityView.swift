//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI
import CoreData
import Charts

struct BarChartActivityView: View {
    var data: [ExpenseItem]
    var title: String
    var height: CGFloat
    
    var body: some View {
        GroupBox(title) {
            Chart {
                ForEach(data, id: \.type) { item in
                    BarMark(x: .value("Date", "\(item.date!.toString(dateStyle: .short, timeStyle: .none))"),
                            y: .value("Amount", item.amount))
                    .cornerRadius(12.0)
                    .foregroundStyle(item.type == "Spending" ? .red : .green)
                    .position(by: .value("Type", item.type!))
                }
            }
            .frame(height: height)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.orange.opacity(0.1))
                    .border(.orange, width: 2)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            HStack{
                HStack {
                    Color.red.frame(width: 20, height: 20)
                        .cornerRadius(20)
                    Text("Spending")
                }
                HStack {
                    Color.green.frame(width: 20, height: 20)
                        .cornerRadius(20)
                    Text("Receiving")
                }
            }
        }
    }
}

struct BarChartActivityView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartActivityView(data: [], title: "Last 7 Days Activity", height: CGFloat(400))
    }
}
