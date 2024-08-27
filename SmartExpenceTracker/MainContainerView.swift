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
    @Environment(AnalyzingGPT.self) var gpt
    let textComponent: TextComponent = TextComponent(tabs: ["자산", "소비﹒수입", "연말정산"], selectedColor: Color.primary)
    let underline: UnderLineComponent = UnderLineComponent(visible: true, color: Color.primary, thickness: 1.0)
    
    var body: some View {
        @Bindable var bindableViewState = viewState
        @Bindable var bindableGPT = gpt
//        TopTabBar(content: {
//            Text("First View")
//
//            Text("Second View")
//        }, text: textComponent, underline: underline, visible: $bindableViewState.topTabBarExist)
        NavigationStack(path: $bindableViewState.stack) {
            IncomeExpenceView()
//                .onAppear {
//                    withAnimation(.linear) {
//                        viewState.topTabBarExist = true
//                    }
//                    
//                }
//                .onDisappear {
//                    viewState.topTabBarExist = false
//                }
                .sheet(isPresented: $bindableGPT.finishAnalyze) {
                    SavingExpenceView(viewState: viewState, gpt: bindableGPT)
                        .presentationDetents([.fraction(0.35), .large])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                        .interactiveDismissDisabled()
                        .opacity(0.8)
                }
        }

    }
}

#Preview {
    MainContainerView()
        .environment(ViewState())
        .environment(AnalyzingGPT())
        .modelContainer(previewReceiptContainer)

}



