//
//  TestAppApp.swift
//  TestApp
//

//

import SwiftUI
import SwiftData

@main
struct MyWallet: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DataItem.self)
    }
}
