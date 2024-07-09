//
//  SmartExpenceTrackerApp.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI

@main
struct SmartExpenceTrackerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(GPT())
        }
    }
}
