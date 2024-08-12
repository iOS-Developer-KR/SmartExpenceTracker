//
//  DateSelectView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/3/24.
//

import SwiftUI

struct DateSelectView: View {
    
    @Binding var selected: Bool
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundStyle(Color.gray)
            }
            
            Button {
                selected.toggle()
            } label: {
                Text("8월")
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
}

#Preview {
    DateSelectView(selected: .constant(false))
}
