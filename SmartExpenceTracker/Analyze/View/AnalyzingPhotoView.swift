//
//  AnalyzingPhotoView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AnalyzingPhotoView: View {
    @Environment(ViewState.self) var viewState
    @Environment(AnalyzingGPT.self) var gpt
    @State private var isOpacity: Bool = false
    @State private var isOffset: Bool = false
    @State private var pressed: Bool = false
    
    @Binding var selectedImage: UIImage?
    @Binding var topTabBarExist: Bool
    
    var body: some View {
        @Bindable var bindableGPT = gpt
//        ZStack {

//            GeometryReader(content: { geometry in
                VStack {
                    Button {
                        topTabBarExist.toggle()
                        print(viewState.topTabBarExist)
                        print(":시발")

                    } label: {
                        Text("지우기")
                    }
                    
                    Button {
                        viewState.topTabBarExist = false
                    } label : {
                        Text("abc")
                    }

                    Spacer()
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    Spacer()
                }
                .onAppear {
                    print(":시발")
                    viewState.topTabBarExist = false
                }
                .sheet(isPresented: $pressed) {
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
                                Text("분석하기")
                        }
                    }
                }
                
                if !gpt.analyzed {
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
        
                
//            })
//        }
        


    }
}

extension AnalyzingPhotoView {
    @MainActor func analyze() {
        guard selectedImage != nil else { return }
        gpt.analyze(pressed: $pressed)
    }
}

#Preview {
    AnalyzingPhotoView(selectedImage: .constant(.japan1), topTabBarExist: .constant(false))
        .environment(AnalyzingGPT())
        .environment(ViewState())
}
