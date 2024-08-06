//
//  DateSelectView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/3/24.
//

import SwiftUI

struct DateSelectView: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundStyle(Color.gray)
            }
            
            Button {
                
            } label: {
                Text("8월")
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
    DateSelectView()
}
