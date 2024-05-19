//
//  MinusHistory.swift
//  MyWallet


import Foundation
import SwiftUI

struct MinusHistory: View {
    @Environment(\.managedObjectContext) private var context
    @State public var items: [DataItem]

    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text("Amount: \(getAmount(from: item.name))")
                    Text("Category: \(getCategory(from: item.name))")
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Expense History")
    }

    func getAmount(from itemName: String) -> String {
        let components = itemName.components(separatedBy: ":")
        return components.last?.trimmingCharacters(in: .whitespaces) ?? ""
    }

    func getCategory(from itemName: String) -> String {
        let components = itemName.components(separatedBy: ":")
        return components.first?.trimmingCharacters(in: .whitespaces) ?? ""
    }

    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        try? context.save()
    }
}
