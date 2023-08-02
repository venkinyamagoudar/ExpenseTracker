//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI
import CoreData

struct HomeView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss

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

    @State private var isShowingAddView = false
    @State private var selectedSortingCriteria: SortingCriteria = .date

    private var items: FetchedResults<ExpenseItem> {
        switch selectedSortingCriteria {
        case .amount:
            return sortByAmountItems
        case .title:
            return sortByTitleItems
        case .date:
            return sortByDateItems
        }
    }

    private var hasItems: Bool {
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

    var body: some View {
        ZStack{
            if hasItems {
                VStack {
                    Group {
                        Picker("Sort By", selection: $selectedSortingCriteria) {
                            ForEach(SortingCriteria.allCases, id: \.self) { criteria in
                                Text(criteria.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                    Group {
                        VStack {
                            Text("Total Expense")
                                .font(.headline)
                                .padding(.top, 10)
                            Text(totalAmount)
                                .font(.title)
                                .padding(.bottom, 10)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color(uiColor: .systemBlue))
                        .foregroundColor(.primary)
                        .cornerRadius(10)

                        HStack {
                            AmountTypeView(amount: recivedAmount, type: .receiving)
                            AmountTypeView(amount: spendingAmount, type: .spending)
                        }
                    }
                    .padding(.horizontal)
                    List {
                        ForEach(items) { item in
                            NavigationLink(destination: EditView(item: item)) {
                                ExpenseListCellView(item: item)
                            }
                        }
                        .onDelete(perform: deleteExpense)
                    }
                    .listStyle(.sidebar)
                }
            } else {
                VStack{
                    AddLottieView(lottieFileName: LottieFiles.noItemsPresent)
                }
            }
            Spacer()
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isShowingAddView = true
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                    .background(Color.blue)
                    .cornerRadius(35)
                    .padding()
                }
            }
        }
        .navigationTitle("iExpense")
        .toolbar {
            EditButton().disabled(!hasItems)
        }
        .sheet(isPresented: $isShowingAddView) {
            AddView()
        }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//struct HomeView: View {
//    @Environment(\.managedObjectContext) private var managedObjectContext
//    @ObservedObject private var viewModel: HomeViewModel
//
//    var body: some View {
//        ZStack{
//            if viewModel.hasItems {
//                VStack {
//                    Group {
//                        Picker("Sort By", selection: $viewModel.selectedSortingCriteria) {
//                            ForEach(SortingCriteria.allCases, id: \.self) { criteria in
//                                Text(criteria.rawValue.capitalized)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                        .padding(.vertical)
//                    }
//                    .padding(.horizontal)
//                    Group {
//                        VStack {
//                            Text("Total Expense")
//                                .font(.headline)
//                                .padding(.top, 10)
//                            Text(viewModel.totalAmount)
//                                .font(.title)
//                                .padding(.bottom, 10)
//                                .lineLimit(1)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                        .background(Color(uiColor: .systemBlue))
//                        .foregroundColor(.primary)
//                        .cornerRadius(10)
//
//                        HStack {
//                            AmountTypeView(amount: viewModel.recivedAmount, type: .receiving)
//                            AmountTypeView(amount: viewModel.spendingAmount, type: .spending)
//                        }
//                    }
//                    .padding(.horizontal)
//                    List {
//                        ForEach(viewModel.items) { item in
//                            NavigationLink(destination: EditView(item: item)) {
//                                ExpenseListCellView(item: item)
//                            }
//                        }
//                        .onDelete(perform: viewModel.deleteExpense)
//                    }
//                    .listStyle(.sidebar)
//                }
//            } else {
//                VStack {
//                    AddLottieView(lottieFileName: LottieFiles.noItemsPresent)
//                }
//            }
//            Spacer()
//            VStack{
//                Spacer()
//                HStack {
//                    Spacer()
//                    Button {
//                        viewModel.isShowingAddView = true
//                    } label: {
//                        Image(systemName: "plus")
//                            .padding()
//                            .foregroundColor(.white)
//                            .frame(width: 50, height: 50)
//                    }
//                    .background(Color.blue)
//                    .cornerRadius(35)
//                    .padding()
//                }
//            }
//        }
//        .navigationTitle("iExpense")
//        .toolbar {
//            EditButton().disabled(!viewModel.hasItems)
//        }
//        .sheet(isPresented: $viewModel.isShowingAddView) {
//            AddView()
//        }
//    }
//}
