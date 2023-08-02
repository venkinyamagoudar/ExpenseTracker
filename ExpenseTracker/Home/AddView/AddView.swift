//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Venkatesh Nyamagoudar on 8/1/23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var type = "Spending"
    @State private var amount: Double = 0.0
    @State private var date = Date.now
    @State private var note :String = ""
    
    let types = ["Spending", "Receiving"]
    let maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
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
                Section("Amount"){
                    TextField("Amount", value: $amount, format: .localCurrency)
                        .keyboardType(.decimalPad)
                        
                }
                Section("Date"){
                    DatePicker("Date", selection: $date, in: ...maximumDate)
                }
                Section("Note"){
                    TextEditor(text: $note)
                }
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                Button("Save") {
                    addExpense()
                    dismiss()
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addExpense() {
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
        
        let newItem = ExpenseItem(context: managedObjectContext)
        newItem.id = UUID()
        newItem.title = title
        newItem.type = type
        newItem.amount = amount
        newItem.date = date
        newItem.note = note
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

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
