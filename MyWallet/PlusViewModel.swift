//
//  PlusViewModel.swift
//  MyWallet
//

import Foundation

class PlusViewModel: ObservableObject {
  @Published var amount: Double = 0.0
  @Published var selectedCategory: String = "Salary"
  @Published var submission: Submission? = nil
  
  func submitIncome(context: DataContext) {
    if amount > 0 {
      let newItem = DataItem(name: "\(selectedCategory): \(amount)€")
      context.insert(newItem)
      submission = Submission(amount: amount, category: selectedCategory)
      // Notify ContentView about the update (new approach)
      objectWillChange.send()
    } else {
      // Zobrazte alert pre prázdnu sumu
    }
  }
}
