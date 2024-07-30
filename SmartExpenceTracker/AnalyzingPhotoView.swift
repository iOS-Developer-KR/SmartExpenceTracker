//
//  AnalyzingPhotoView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AnalyzingPhotoView: View {
    @EnvironmentObject var gpt: GPT
    @State private var isOpacity: Bool = false
    @State private var isOffset: Bool = false
    @State private var image: Image?
    @State private var received: Bool = false
    var selectedImage: UIImage
    
    
    var body: some View {
        
        ZStack {
//            if let image = self.image {
                GeometryReader(content: { geometry in
                    VStack {
                        Spacer()
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
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
                
//            }
        }
        .onAppear {
            analyze()
        }
        .sheet(isPresented: $gpt.navigate) {
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
    func analyze() {
        DispatchQueue.main.async {
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                gpt.analyze(imageData: imageData)//, value: <#T##Binding<Bool>#>)
            }
        }
//        DispatchQueue.main.async {
//            selectedImageItem.loadTransferable(type: Data.self, completionHandler: { result in
//                guard selectedImageItem == self.selectedImageItem else { return }
//                switch result {
//                case .success(let image?):
//                    if let image = UIImage(data: image), let imageData = image.jpegData(compressionQuality: 1.0) {
//                        print("before analysing")
//                        gpt.analyze(imageData: imageData, value: $received)
//                        print("after analysing")
//                    }
//                    guard let uiImage = UIImage(data: image) else { return }
//                    self.image = Image(uiImage: uiImage)
//                case .success(nil): break
//                case .failure(let failure):
//                    print(failure.localizedDescription)
//                    return
//                }
//            })
//        }
    }
}




//#Preview {
//    AnalyzingPhotoView(selectedImageItem: PhotosPickerItem(itemIdentifier: ""))
//        .environmentObject(GPT())
//}

