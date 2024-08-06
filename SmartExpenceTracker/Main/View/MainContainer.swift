//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI

struct MainContainer: View {
    
    @State private var selectedTab = 1
    @State private var verticalOffset: CGFloat = 0
    private let tabs: [String] = ["자산", "소비﹒수입", "연말정산"]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Array(tabs.enumerated()), id: \.offset) { obj in
                    Button {
                        selectedTab = obj.offset
                        print(selectedTab)
                    } label: {
                        Text(obj.element)
                            .foregroundStyle(obj.offset == selectedTab ? Color.accentColor : Color.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Divider()
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        getViewFor(index: index)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .offset(x: -CGFloat(selectedTab) * geometry.size.width + verticalOffset)
                .onAppear {
                    print(geometry.size.width)
                }
                .animation(.easeInOut, value: selectedTab)
                .animation(.easeInOut, value: verticalOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            verticalOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold = geometry.size.width / 2
                            if -value.predictedEndTranslation.width > threshold && selectedTab < tabs.count - 1 {
                                selectedTab += 1
                            } else if value.predictedEndTranslation.width > threshold && selectedTab > 0 {
                                selectedTab -= 1
                            }
                            verticalOffset = 0
                        }
                )
            }
        }
    }
    
    @ViewBuilder
    private func getViewFor(index: Int) -> some View {
        switch index {
        case 0:
            Text("First View")
        case 1:
            IncomeExpenceView()
        case 2:
            Text("Third View")
        default:
            EmptyView()
        }
    }
}

#Preview {
    MainContainer()
}



