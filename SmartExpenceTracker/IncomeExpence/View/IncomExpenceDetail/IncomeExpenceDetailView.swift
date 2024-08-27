//
//  IncomeExpenceDetailView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/22/24.
//

import SwiftUI


struct IncomeExpenceDetailView: View {
    @Environment(ViewState.self) private var viewState
    @Bindable var recordReceipts: RecordReceipts
    @State private var editAmount: Bool = false
    
    var body: some View {
        
        VStack {
            HeaderComponent
            
            CategoryComponent

            MemoComponent
            
            DateComponent
            
            Spacer()
            
        }
        .navigationTitle("상세 내역")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewState.topTabBarExist = false
        }
        
    }
    
    @ViewBuilder private var HeaderComponent: some View {
        HStack {
            recordReceipts.category.icon
                .foregroundStyle(recordReceipts.category.color)
            Text(recordReceipts.title)
            Spacer()
        }.padding()
        
        HStack {
            Text("\(recordReceipts.amount)원")
            Button {
                editAmount = true
            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(Color.gray)
                    .bold()
            }
            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $editAmount, content: {
            CalculatorView(displayText: recordReceipts.amount.description, amount: $recordReceipts.amount)
                .presentationDetents([.fraction(0.65)])
                .presentationDragIndicator(.visible)
                .padding()
        })
    }
    
    @ViewBuilder private var MemoComponent: some View {
        NavigationLink {
            EditMemoView(text: $recordReceipts.memo)
        } label: {
            HStack {
                Text("메모")
                    .foregroundStyle(Color.white)
                Spacer()
                Text(recordReceipts.memo.isEmpty ? "메모를 남겨보세요" : recordReceipts.memo)
                    .foregroundStyle(recordReceipts.memo.isEmpty ? Color.accentColor : Color.white)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder private var CategoryComponent: some View {
        NavigationLink {
            EditCategoryView(recipts: recordReceipts)
        } label: {
            HStack {
                Text("카테고리 설정")
                    .foregroundStyle(Color.white)
                Spacer()
                Text(recordReceipts.category.displayName)
            }
            .padding()
        }
    }
    
    @ViewBuilder private var DateComponent: some View {
        HStack {
            Text("결제일시")
            Spacer()
            Text(recordReceipts.date)
        }.padding()
    }
}

#Preview {
    NavigationStack {
        IncomeExpenceDetailView(recordReceipts: SampleData.receiptDefaultModel.first!)
            .environment(ViewState())
    }
}


