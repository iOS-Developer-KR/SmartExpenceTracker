//
//  AnalyzingPhotoView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AnalyzingPhotoView: View {
    @Environment(AnalyzingGPT.self) var gpt
    @State private var isOpacity: Bool = false
    @State private var isOffset: Bool = false
    @State private var received: Bool = false
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        @Bindable var bindableGPT = gpt
        ZStack {
            GeometryReader(content: { geometry in
                VStack {
                    Spacer()
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Spacer()
                    
                }
                
                if !gpt.navigate {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 400, height: 5)
                        .opacity(isOpacity ? 0.3 : 0.8)
                        .offset(y: isOffset ? -20 : (UIScreen.current?.bounds.height)! - 100)
                        .overlay(
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 400, height: 50)
                                .opacity(isOpacity ? 0.3 : 0.8)
                                .offset(y: isOffset ? 0 : (UIScreen.current?.bounds.height)! - 120)
                        )
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                isOpacity.toggle()
                            }
                            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                                isOffset.toggle()
                            }
                        }
                }
                
            })
        }
        .sheet(isPresented: $bindableGPT.navigate) {
            SavingExpenceView()
                .presentationDetents([.medium, .fraction(0.2), .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
                .opacity(0.8)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    analyze()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

extension AnalyzingPhotoView {
    @MainActor func analyze() {
        guard let image = selectedImage else { return }
        gpt.analyze()
        
    }
    
}




//#Preview {
//    AnalyzingPhotoView()
//        .environment(AnalyzingGPT())
//}

