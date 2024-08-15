//
//  PhotoDecisionView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/16/24.
//

import SwiftUI
import PhotosUI

struct PhotoDecisionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TopTabBarState.self) var barState
    @Environment(AnalyzingGPT.self) var gpt
    @Binding var selectedImage: UIImage?
    var body: some View {
        
        if let uiImage = selectedImage {
            Image(uiImage: uiImage)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            gpt.selectedImage = selectedImage
                            dismiss()
                        } label: {
                            Text("분석하기")
                        }
                    }
                }
                .onAppear {
                    barState.exist = false
                }
        }
        
    }
}

#Preview {
    PhotoDecisionView(selectedImage: .constant(.japan1))
}
