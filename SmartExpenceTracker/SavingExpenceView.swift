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
        Text(gpt.result.category)
        Text(gpt.result.date)
        Text("\(gpt.result.amount)")
    }
}

#Preview {
    SavingExpenceView()
        .environmentObject(GPT())
}
