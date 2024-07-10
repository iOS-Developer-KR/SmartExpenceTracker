//
//  SavingExpenceView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI

struct SavingExpenceView: View {
    
    @EnvironmentObject var gpt: GPT
    
    var body: some View {
        VStack {
            
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
                Text(gpt.result.category)
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
        .environmentObject(GPT())
}



func convertToDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // 문자열의 형식을 지정
    return formatter.date(from: string)
}

