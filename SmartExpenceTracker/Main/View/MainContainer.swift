//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import YTWSwiftUILibrary

struct MainContainer: View {
    
    let textComponent: TextComponent = TextComponent(tabs: ["자산", "소비﹒수입", "연말정산"], selectedColor: Color.primary)
    let underline: UnderLineComponent = UnderLineComponent(visible: true, color: Color.primary, thickness: 1.0)
    
    var body: some View {
        
        TopTabBar(content: {
            Text("First View")
            IncomeExpenceView()
            Text("Second View")
        }, text: textComponent, underline: underline)
    }
}

#Preview {
    MainContainer()
        .environment(AnalyzingGPT())
}



