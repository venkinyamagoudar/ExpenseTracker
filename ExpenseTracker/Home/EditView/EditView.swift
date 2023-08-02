//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI
import CoreData

struct EditView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var item: ExpenseItem
    
    @State private var title: String
    @State private var type: String
    @State private var amount: Double
    @State private var date: Date
    @State private var note: String
    
    let types = ["Spending", "Receiving"]
    let maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    
    init(item: ExpenseItem) {
        self.item = item
        _title = State(initialValue: item.title ?? "")
        _type = State(initialValue: item.type ?? "Spending")
        _amount = State(initialValue: item.amount)
        _date = State(initialValue: item.date ?? Date())
        _note = State(initialValue: item.note ?? "")
    }
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        Form {
            Section("Title") {
                TextField("Expense", text: $title)
            }
            Section("Type") {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
            }
            Section("Amount") {
                TextField("Amount", value: $amount, format: .localCurrency)
                    .keyboardType(.decimalPad)
            }
            Section("Date") {
                DatePicker("Date", selection: $date, in: ...maximumDate)
            }
            Section("Note") {
                TextEditor(text: $note)
            }
        }
        .navigationTitle("Edit Expense")
        .toolbar {
            Button("Save") {
                updateExpense()
                dismiss()
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }   
    }
    
    private func updateExpense() {
        guard !title.isEmpty else {
            showError = true
            errorMessage = "Title cannot be empty"
            return
        }
        
        guard amount > 0 else {
            showError = true
            errorMessage = "Amount must be greater than zero"
            return
        }
        
        item.title = title
        item.type = type
        item.amount = amount
        item.date = date
        item.note = note
        saveItems()
        dismiss()
    }
    
    private func saveItems() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
