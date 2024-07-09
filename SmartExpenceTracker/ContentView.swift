//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @Environment(GPT.self) var gpt
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showDialog: Bool = false
    @State private var photopicker: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
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
                Button("사진찍기") {}
                Button("엘범선택") { photopicker.toggle() }
            } message: {
                Text("분석할 영수증을 선택하세요")
            }
            .padding()

            .navigationDestination(item: $selectedImageItem, destination: { data in
                PhotosSavingView(selectedImageItem: selectedImageItem!)
            })
            .photosPicker(isPresented: $photopicker, selection: $selectedImageItem)
        }
    }
}

#Preview {
    ContentView()
        .environment(GPT())
}

struct PhotosSavingView: View {
    @State private var animationOffset: CGFloat = -200
    @State private var selectedImageData: Data?
    var selectedImageItem: PhotosPickerItem
    
    
    var body: some View {
        VStack {
            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 300, height: 2)
                    .offset(y: animationOffset)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: true)) {
                            animationOffset = 200
                        }
                    }
            }
        }
        .onAppear {
            selectedImageItem.loadTransferable(type: Data.self, completionHandler: { result in
                DispatchQueue.main.async {
                    guard selectedImageItem == self.selectedImageItem else { return }
                    switch result {
                    case .success(let image?):
                        selectedImageData = image
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
