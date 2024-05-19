//
//  PlusView.swift
//  MyWallet
//

//

import SwiftUI
import Combine
import SwiftData

struct Submission1: Identifiable {
    var id = UUID()
    var amount: Double
    var category: String
    var date: Date
}

struct MinusView: View {
    @State private var amount = ""
    @State private var selectedExpenseCategory = "Groceries"
    @State private var submission: Submission1? = nil
    @State private var showAlertForEmptyAmount = false
    @State private var selectedDate = Date()
    @Query private var items: [DataItem]
    
    @EnvironmentObject var moneyManager: MoneyManager
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Spacer()
                NavigationLink(destination: MinusHistory(items: items)) {
                    Image("history")
                }

                Text("New expense")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                
                TextField("Enter amount in EUR", text: $amount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(width: 300, height: 30)
                    .onReceive(Just(amount)) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.amount = filtered
                        }
                    }
                    .padding(.bottom, 10)

                Text("Select Category")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .offset(y: 20)

                Picker("Expense Category", selection: $selectedExpenseCategory) {
                    Label("Groceries", systemImage: "cart.fill")
                        .foregroundColor(Color.white)
                        .tag("Groceries")

                    Label("Utilities", systemImage: "bolt.fill")
                        .foregroundColor(Color.white)
                        .tag("Utilities")

                }
                .pickerStyle(WheelPickerStyle())
                .offset(y: -50)
                .padding(.bottom, 10)

                DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal, 50.0)
                    .offset(y: -30)

                Button(action: {
                    if let amountValue = Double(amount) {
                        moneyManager.updateCategory(category: selectedExpenseCategory, amount: +amountValue, date: selectedDate)
                        submission = Submission1(amount: amountValue, category: selectedExpenseCategory, date: selectedDate)
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .offset(y: -20)
                }
                .alert(isPresented: $showAlertForEmptyAmount) {
                    Alert(title: Text("Error"), message: Text("Please enter a valid amount."), dismissButton: .default(Text("OK")))
                }
                .alert(item: $submission) { submission in
                    let formattedAmount = String(format: "%.2f", submission.amount)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let formattedDate = dateFormatter.string(from: submission.date)
                    return Alert(title: Text("Submitted!"), message: Text("Amount: \(formattedAmount)€\nCategory: \(submission.category)\nDate: \(formattedDate)"), dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
        }
    }
}






#Preview {
    MinusView()
}
