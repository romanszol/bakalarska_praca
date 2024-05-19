//
//  DataItem.swift
//  MyWallet
//

import Foundation
import SwiftData
import CoreData

@Model
class DataItem{
    var id: String
    var name: String
    var date: Date?
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.date = Date()
        
    }
    
}

