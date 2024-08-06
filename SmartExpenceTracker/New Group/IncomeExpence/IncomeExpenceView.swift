//
//  IncomeExpenceView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/3/24.
//

import SwiftUI
import PhotosUI

struct IncomeExpenceView: View {
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog = false
    @State private var photoPicker = false
    @State private var captureImage = false
    
    var body: some View {
        NavigationStack {


                VStack {
                    
                    DateSelectView()
                    
                    HStack {
                        
                        Text("원")
                        Spacer()
                    }.padding(.horizontal)
                    
                    
                    
                    
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showDialog.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            
            .confirmationDialog("Selection", isPresented: $showDialog) {
                Button("사진찍기") { captureImage.toggle() }
                Button("앨범 선택") { photoPicker.toggle() }
            }
            .photosPicker(isPresented: $photoPicker, selection: $selectedImageItem, matching: .images)
            .fullScreenCover(isPresented: $captureImage) {
                AccessCameraView(selectedImage: $selectedImage)
            }
            .onChange(of: selectedImageItem) { oldItem, newItem in
                loadImage(from: newItem)
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    selectedImage = UIImage(data: data)
                }
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    
}

#Preview {
    IncomeExpenceView()
}


