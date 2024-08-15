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
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Button {
                    let newReceipts = Receipts(title: gpt.result.title, amount: gpt.result.amount, category: gpt.result.category, date: gpt.result.date)
                    dbContext.insert(newReceipts)
                } label: {
                    Text("Save")
                        .padding()
                }
            }
            
            Divider()
            
            HStack {
                DatePicker(selection: .constant(convertToDate(from: gpt.result.date) ?? Date())) {
                    Text("Date")
                        .padding()
                }
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("category")
                Spacer()
                gpt.result.category.icon
                Text(gpt.result.category.displayName)
            }
            .padding()
            
            Divider()
            
            HStack {
                Text("title")
                Spacer()
                Text(gpt.result.title)
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
                Text("\(gpt.result.amount)")
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

