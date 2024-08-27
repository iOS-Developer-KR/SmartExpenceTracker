//
//  EditMemoView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/23/24.
//

import SwiftUI

struct EditMemoView: View {
    @FocusState private var textFieldInFocus: Bool
    @Binding var text: String
    var body: some View {
        TextField(text, text: $text)
            .focused($textFieldInFocus)
            .onAppear {
                textFieldInFocus.toggle()
            }
            .multilineTextAlignment(.center)
    }
}

#Preview {
    EditMemoView(text: .constant(""))
}
