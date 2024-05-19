//
//  DataPoint.swift
//  MyWallet
//

import Foundation

struct Category : Identifiable, Equatable {
    var id = UUID().uuidString
    var cat : String
    var cost : Double
    var date: Date?
}
