//
//  SavingExpenceView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI
import SwiftData

struct SavingExpenceView: View {
    
    @Environment(\.modelContext) var dbContext
    @Environment(AnalyzingGPT.self) var gpt
    @Environment(ViewState.self) var barState

    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Button {
                    if let title = gpt.result?.title, let amount = gpt.result?.amount, let category = gpt.result?.category, let date = gpt.result?.date/*, let marchant = gpt.result?.marchant*/ {
                        let newReceipts = Receipts(title: title, amount: amount, category: category, date: date/*, marchant: marchant*/)
                        dbContext.insert(newReceipts)
                        barState.stack = .init()
                    }
                } label: {
                    Text("Save")
                        .padding()
                }
            }
            
            Divider()
            
            HStack {
                DatePicker(selection: .constant(convertToDate(from: gpt.result?.date ?? "") ?? Date())) {
                    Text("Date")
                        .padding()
                }
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("category")
                Spacer()
                if let icon = gpt.result?.category.icon {
                    icon
                }
                
                Text(gpt.result?.category.displayName ?? "알수없음")
            }
            .padding()
            
            Divider()
            
            HStack {
                Text("title")
                Spacer()
                Text(gpt.result?.title ?? "알수없음")
            }
            .padding()
            
            Divider()
            
            List(gpt.marchants) { mar in
                VStack {
                    HStack {
                        Text("name")
                        Spacer()
                        Text(mar.object)
                    }
                    HStack {
                        Text("price")
                        Spacer()
                        Text("\(mar.price)")
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("amount")
                Spacer()
                Text("\(gpt.result?.amount ?? 0)")
            }
            .padding()
            
            Divider()
            
            Spacer()
        }
        
    }
}

#Preview {
    SavingExpenceView()
        .environment(AnalyzingGPT())
}



func convertToDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // 문자열의 형식을 지정
    return formatter.date(from: string)
}

