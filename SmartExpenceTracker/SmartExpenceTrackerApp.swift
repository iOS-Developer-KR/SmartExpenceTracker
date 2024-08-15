//
//  SmartExpenceTrackerApp.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import SwiftData

@main
struct SmartExpenceTrackerApp: App {

    @State private var gpt = AnalyzingGPT()
//    @State private var receipts = Receipts()
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Receipts.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainContainer()
                .environment(gpt)
//                .environment(receipts)
                
        }
        .modelContainer(modelContainer)
    }
}
