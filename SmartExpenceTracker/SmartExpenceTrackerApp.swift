//
//  SmartExpenceTrackerApp.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI

@main
struct SmartExpenceTrackerApp: App {

    @State var gpt = GPT()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gpt)
        }
    }
}
