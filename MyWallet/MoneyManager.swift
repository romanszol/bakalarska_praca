//
//  MoneyManager.swift
//  MyWallet
//

import Foundation

let specificDate = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 14))!
let specificDate1 = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 13))!
let specificDate2 = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 12))!

class MoneyManager: ObservableObject {
    @Published var data: [Category] = [
        Category(cat: "Salary", cost: 140, date: specificDate),
        Category(cat: "Business", cost: 70, date: specificDate),
        Category(cat: "Investments", cost: 70, date: specificDate),
        Category(cat: "Gifts", cost: 100, date: specificDate1),
        Category(cat: "Others", cost: 120, date: specificDate2),
        Category(cat: "Utilities", cost: 90, date: specificDate),
        Category(cat: "Groceries", cost: 140, date: specificDate),
    ]

    func updateCategory(category: String, amount: Double, date: Date) {
        if let index = data.firstIndex(where: { $0.cat == category }) {
            data[index].cost += amount
            data[index].date = date
        }
    }
}

