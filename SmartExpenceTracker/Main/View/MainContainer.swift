//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import YTWSwiftUILibrary

struct MainContainer: View {
    
    @State private var selectedTab = 1
    @State private var verticalOffset: CGFloat = 0
    private let tabs: [String] = ["자산", "소비﹒수입", "연말정산"]
    
    var body: some View {
        TopTabBar(content: {
            Text("First View")
            IncomeExpenceView()
            Text("Second View")
        }, arr: tabs)
    }
}

#Preview {
    MainContainer()
        .environment(AnalyzingGPT())
}



