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
        Form {
            VStack {
                HStack {
                    DatePicker(selection: .constant(convertToDate(from: gpt.result.date) ?? Date())) {
                        Text("Date")
                            .padding()
                    }
                    Spacer()
                }
                
                HStack {
                    Text("category")
                    Spacer()
                    Text(gpt.result.category)
                }
                .padding()
                
                Text(gpt.result.date)
                Text("\(gpt.result.amount)")
            }
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

