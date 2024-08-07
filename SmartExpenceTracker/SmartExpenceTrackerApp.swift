//
//  SmartExpenceTrackerApp.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI

@main
struct SmartExpenceTrackerApp: App {

    @State var gpt = AnalyzingGPT()
    
    var body: some Scene {
        WindowGroup {
            MainContainer()
                .environment(gpt)
        }
    }
}
