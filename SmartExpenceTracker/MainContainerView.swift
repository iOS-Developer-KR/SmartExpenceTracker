//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import YTWSwiftUILibrary

struct MainContainerView: View {
    @Environment(ViewState.self) var viewState
    
    let textComponent: TextComponent = TextComponent(tabs: ["자산", "소비﹒수입", "연말정산"], selectedColor: Color.primary)
    let underline: UnderLineComponent = UnderLineComponent(visible: true, color: Color.primary, thickness: 1.0)
    
    var body: some View {
        @Bindable var bindableViewState = viewState
        TopTabBar(content: {
            Text("First View")
            NavigationStack(path: $bindableViewState.stack) {
                
                IncomeExpenceView()
            }
            Text("Second View")
        }, text: textComponent, underline: underline, visible: $bindableViewState.topTabBarExist)
    }
}

#Preview {
    MainContainerView()
        .environment(ViewState())
        .environment(AnalyzingGPT())
}



