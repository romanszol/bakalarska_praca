import SwiftUI
import Combine
import SwiftData

struct Submission: Identifiable {
    var id = UUID()
    var amount: Double
    var category: String
    var date: Date?
}

struct PlusView: View {
    @EnvironmentObject var moneyManager: MoneyManager
    @Environment(\.modelContext) private var context
    @Query private var items: [DataItem]
    @State private var amount = ""
    @State private var selectedCategory = "Salary"
    @State private var submission: Submission? = nil
    @State private var showAlertForEmptyAmount = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                NavigationLink(destination: PlusHistory(items: items)) {
                    Image("history")
                }
                
                Text("New Income")
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
                
                Picker("Category", selection: $selectedCategory) {
                    Label("Salary", systemImage: "dollarsign.circle")
                        .foregroundColor(Color.white)
                        .tag("Salary")
                    
                    Label("Business", systemImage: "briefcase.fill")
                        .foregroundColor(Color.white)
                        .tag("Business")
                    
                    Label("Investments", systemImage: "chart.bar.fill")
                        .foregroundColor(Color.white)
                        .tag("Investments")
                    
                    Label("Gifts", systemImage: "gift")
                        .foregroundColor(Color.white)
                        .tag("Gifts")
                    
                    Label("Others", systemImage: "ellipsis.circle.fill")
                        .foregroundColor(Color.white)
                        .tag("Others")
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
                  if let amountValue = Double(amount), !amount.isEmpty {
                    moneyManager.updateCategory(category: selectedCategory, amount: amountValue, date: selectedDate)
                    let newItem = DataItem(name: "\(selectedCategory): \(amountValue)€ - \(formattedDate(date: selectedDate))")
                    context.insert(newItem)
                    submission = Submission(amount: amountValue, category: selectedCategory, date: selectedDate)
                  } else {
                    showAlertForEmptyAmount = true
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
                  let formattedDate = self.formattedDate(date: submission.date!)
                  return Alert(title: Text("Submitted!"), message: Text("Amount: \(formattedAmount)€\nCategory: \(submission.category)\n Date: \(formattedDate)"), dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
        }
    }

    
    func getAmount(from itemName: String) -> String {
        let components = itemName.components(separatedBy: ":")
        return components.last?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    func getCategory(from itemName: String) -> String {
        let components = itemName.components(separatedBy: ":")
        return components.first?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    func deleteItem(_ item: DataItem) {
        context.delete(item)
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
      }
    }



#Preview {
    PlusView()
}
