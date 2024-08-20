//
//  CalendarView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/31/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedTab = 0
    @State private var offset: CGFloat = 0
    @State private var dragging: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        getViewFor(index: index)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .frame(width: geometry.size.width * 3, height: geometry.size.height, alignment: .leading)
                .offset(x: -CGFloat(selectedTab) * geometry.size.width + offset)
                .animation(dragging ? .none : .easeInOut, value: selectedTab)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragging = true
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            dragging = false
                            let threshold = geometry.size.width / 2
                            if value.translation.width < -threshold && selectedTab < 2 {
                                selectedTab += 1
                            } else if value.translation.width > threshold && selectedTab > 0 {
                                selectedTab -= 1
                            }
                            offset = 0
                        }
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func getViewFor(index: Int) -> some View {
        switch index {
        case 0:
            Text("First View")
                .background(Color.red)
        case 1:
            Text("Second View")
                .background(Color.green)
        case 2:
            Text("Third View")
                .background(Color.blue)
        default:
            EmptyView()
        }
    }
}

#Preview {
    CalendarView()
}
