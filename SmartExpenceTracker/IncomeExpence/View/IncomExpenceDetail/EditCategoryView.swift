//
//  EditCategoryView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/23/24.
//

import SwiftUI

struct PressableStyle: ButtonStyle {
    
    let scaledAmount: CGFloat
    
    init(scaledAmount: CGFloat = 0.96) {
            self.scaledAmount = scaledAmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .contentShape(Rectangle())
    }
}

struct EditCategoryView: View {
    @Bindable var recipts: RecordReceipts
    var body: some View {
        
        VStack {
            HearComponent
            
            DetailComponent
            
            CategorySelection
            
            Spacer()
        }
    }
    
    
    @ViewBuilder private var HearComponent: some View {
        
        HStack {
            Text("변경할 카테고리를 선택해주세요")
                .font(.title3)
                .bold()
            Spacer()
        }.padding()
    }
    
    @ViewBuilder private var DetailComponent: some View {
        HStack {
            VStack {
                HStack {
                    Text(recipts.title)
                    Spacer()
                }
                HStack {
                    Text("\(recipts.amount) 원")
                    Spacer()
                }
            }
            Spacer()
        }.padding(.horizontal)
    }
    
    @ViewBuilder private var CategorySelection: some View {
        ScrollView {
            ForEach(Category.allCases, id: \.self) { category in
                Button {
                    recipts.category = category
                } label: {
                    HStack {
                        category.icon
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(category.color)
                        
                        Text(category.displayName)
                        Spacer()
                        if recipts.category == category {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                                .bold()
                        }
                    }
                    .padding()
                }
                .buttonStyle(PressableStyle())
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditCategoryView(recipts: SampleData.receiptDefaultModel.first!)
    }
}
