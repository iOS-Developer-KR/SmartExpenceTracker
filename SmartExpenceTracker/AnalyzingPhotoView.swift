//
//  AnalyzingPhotoView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AnalyzingPhotoView: View {
//    @State private var selectedImageData: Data?
//    @State private var opc: Double = 0.3
    @State private var isOpacity: Bool = false
    @State private var isOffset: Bool = false
    @State private var image: Image?
    var selectedImageItem: PhotosPickerItem
    
    
    var body: some View {
        
        ZStack {
            if let image = self.image {
                GeometryReader(content: { geometry in
                    VStack {
                        Spacer()
                        image
                            .resizable()
                            .scaledToFill()
                        Spacer()
                    }
                    
                    
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
                })
                
            }
        }
        
        
        .onAppear {
            selectedImageItem.loadTransferable(type: Data.self, completionHandler: { result in
                DispatchQueue.main.async {
                    guard selectedImageItem == self.selectedImageItem else { return }
                    switch result {
                    case .success(let image?):
                        var selectedImageData = image
                        var data = selectedImageData
                        guard let uiImage = UIImage(data: data) else { return }
                        self.image = Image(uiImage: uiImage)
                    case .success(nil): break
                    case .failure(let failure):
                        print(failure.localizedDescription)
                        return
                    }
                }
            })
        }
        
    }
}


#Preview {
    AnalyzingPhotoView(selectedImageItem: PhotosPickerItem(itemIdentifier: ""))
}
