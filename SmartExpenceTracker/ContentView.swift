//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var photopicker: Bool = false
    @State private var captureImage: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedImage = self.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                }
                Text("흠")
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        
                        Button {
                            showDialog.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .confirmationDialog("Selection", isPresented: $showDialog) {
                Button("사진찍기") { captureImage.toggle() }
                Button("엘범선택") { photopicker.toggle() }
            } message: {
                Text("분석할 영수증을 선택하세요")
            }
            .padding()
            
            .navigationDestination(item: $selectedImage, destination: { data in
                if let selectedImage = selectedImage {
                    AnalyzingPhotoView(selectedImage: selectedImage)
                }
            })
            .photosPicker(isPresented: $photopicker, selection: $selectedImageItem, matching: .images)
            .fullScreenCover(isPresented: $captureImage, content: {
                AccessCameraView(selectedImage: $selectedImage)
            })
            .onChange(of: selectedImage) { oldValue, newValue in
                transform()
            }
        }
    }
}

extension ContentView {
    func transform() {
        DispatchQueue.main.async {
            selectedImageItem?.loadTransferable(type: Data.self, completionHandler: { result in
                guard selectedImageItem == self.selectedImageItem else { return }
                switch result {
                case .success(let image?):
                    selectedImage = UIImage(data: image)
                case .success(nil): break
                case .failure(let failure):
                    print(failure.localizedDescription)
                    return
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
