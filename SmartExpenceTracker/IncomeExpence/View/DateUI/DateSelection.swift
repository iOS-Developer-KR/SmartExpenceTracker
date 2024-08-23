//
//  DateSelectView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/3/24.
//

import SwiftUI

struct DateSelection: View {
    
    @Binding var currentDate: Date
    @Binding var selected: Bool
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundStyle(Color.gray)
            }
            
            Button {
                withAnimation(.spring) {
                    selected.toggle()
                }
                
            } label: {
                Text(currentDate, formatter: dateToString)
                    .foregroundStyle(Color.primary)
                    .underline()
                    .padding(.horizontal, 5)
            }
            
            Button {
                
            } label: {
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
        }.padding()
    }
    
    var dateToString: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        formatter.locale = .autoupdatingCurrent
        return formatter
    }
}

#Preview {
    DateSelection(currentDate: .constant(Date()), selected: .constant(false))
}
