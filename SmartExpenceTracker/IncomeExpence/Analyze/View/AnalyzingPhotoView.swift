//
//  AnalyzingPhotoView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AnalyzingPhotoView: View {
    var viewState: ViewState
    @Bindable var bindableGPT: AnalyzingGPT
    @State private var isOpacity: Bool = false
    @State private var isOffset: Bool = false
    
    @Binding var selectedImage: UIImage?
    @Binding var topTabBarExist: Bool
    
    var body: some View {

        GeometryReader(content: { geometry in
            
            VStack {

                Spacer()
                
                if let image = bindableGPT.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()

                }
                Spacer()
            }
            

            
            if !bindableGPT.analyzed {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 400, height: 5)
                    .opacity(isOpacity ? 0.3 : 0.8)
                    .offset(y: isOffset ? -20 : UIScreen.main.bounds.height - 100)
                    .overlay(
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 400, height: 50)
                            .opacity(isOpacity ? 0.3 : 0.8)
                            .offset(y: isOffset ? 0 : UIScreen.main.bounds.height - 120)
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    analyze()
                } label: {
                    Text("분석하기")
                }
            }
        }
        
        
        
    }
}

extension AnalyzingPhotoView {
    @MainActor func analyze() {
        guard selectedImage != nil else { return }
        DispatchQueue.main.async {
            bindableGPT.analyze()
        }
    }
}

#Preview {
    AnalyzingPhotoView(viewState: ViewState(), bindableGPT: AnalyzingGPT(), selectedImage: .constant(.japan1), topTabBarExist: .constant(false)/*, path: .constant(NavigationPath())*/)
//        .environment(AnalyzingGPT())
        .environment(ViewState())
}
