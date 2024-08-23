//
//  IncomeExpenceDetailView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/22/24.
//

import SwiftUI


struct IncomeExpenceDetailView: View {
    
    @Bindable var recordReceipts: RecordReceipts
    
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
        
    }
    
    @ViewBuilder private var HeaderComponent: some View {
        HStack {
            recordReceipts.category.icon
            Text(recordReceipts.title)
            Spacer()
        }.padding()
        
        HStack {
            Text("\(recordReceipts.amount)원")
            Spacer()
        }.padding(.horizontal)
    }
    
    @ViewBuilder private var MemoComponent: some View {
        NavigationLink {
            EditMemoView(text: $recordReceipts.memo)
        } label: {
            HStack {
                Text("메모")
                    .foregroundStyle(Color.white)
                Spacer()
                Text(recordReceipts.memo.isEmpty ? "메모리를 남겨보세요" : recordReceipts.memo)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder private var CategoryComponent: some View {
        NavigationLink {
            
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
    }
}


