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
    @State private var topTabBarState = ViewState()
    @State private var gpt = AnalyzingGPT()
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: RecordReceipts.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainContainerView()
                .environment(gpt)
                .environment(topTabBarState)
                
        }
        .modelContainer(modelContainer)
    }
}
