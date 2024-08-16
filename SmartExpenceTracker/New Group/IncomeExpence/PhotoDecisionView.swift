//
//  PhotoDecisionView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/16/24.
//

import SwiftUI
import PhotosUI

//struct PhotoDecisionView: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(ViewState.self) var barState
//    @Environment(AnalyzingGPT.self) var gpt
//    @Binding var selectedImage: UIImage?
//    @State private var pressed = false
//    var body: some View {
//
//        if let uiImage = selectedImage {
//            Image(uiImage: uiImage)
//                .resizable()
//                .scaledToFit()
//                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button {
//                            gpt.selectedImage = selectedImage
//                            barState.stack = .init()
//                        } label: {
//                            Text("분석하기")
//                        }
//                    }
//                }
//                .navigationDestination(isPresented: $pressed, destination: {
//                    AnalyzingPhotoView(selectedImage: $selectedImage)
//                })
//                
//        }
//        
//    }
//}
//
//#Preview {
//    PhotoDecisionView(selectedImage: .constant(.japan1))
//}
