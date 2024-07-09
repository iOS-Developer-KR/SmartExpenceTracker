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
                if let selectedImageItem = selectedImageItem {
                    PhotosSavingView(selectedImageItem: selectedImageItem)
                        .onAppear {
                            //                            self.selectedImageItem = .none
                        }
                }
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
    @State private var selectedImageData: Data?
    @State private var imageHeight: CGFloat = 0
    @State private var imageWidth: CGFloat = 0
    @State private var imageOffsetY: CGFloat = -(UIScreen.current?.bounds.height)!/2
    @State private var imageOffsetX: CGFloat = (UIScreen.current?.bounds.width)!/2
    @State private var opc: Double = 0.3
    @State private var isOpacity: Bool = false
    @State private var isOffset: Bool = false
    @State private var image: Image?
    var selectedImageItem: PhotosPickerItem
    
    
    var body: some View {
        //            if let data = selectedImageData, let uiImage = UIImage(data: data) {
        //                GeometryReader { geometry in
        ZStack {
            
            
            if let image = self.image {
                GeometryReader(content: { geometry in
                    
                    VStack {
                        Spacer()
                        image
                            .resizable()
                            .scaledToFit()
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
                        selectedImageData = image
                        guard let data = selectedImageData else { return }
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


extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
