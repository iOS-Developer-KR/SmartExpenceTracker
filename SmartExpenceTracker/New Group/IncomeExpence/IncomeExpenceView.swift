//
//  IncomeExpenceView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/3/24.
//

import SwiftUI
import PhotosUI

struct IncomeExpenceView: View {
    @Environment(AnalyzingGPT.self) var gpt
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var currentDate = Date()
    @State private var selectedMonth = false
    @State private var showDialog = false
    @State private var photoPicker = false
    @State private var captureImage = false
    
    let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
    
    var body: some View {
        @Bindable var bindableGPT = gpt
        NavigationStack {

                VStack {
                    
                    DateSelectView(currentDate: $currentDate, selected: $selectedMonth)
                    
                    HStack {
                        
                        Text("0원")
                        Spacer()

                    }.padding(.horizontal)
                    
                    Spacer()
                    
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
            .navigationDestination(item: $bindableGPT.selectedImage, destination: { _ in
                AnalyzingPhotoView(selectedImage: $bindableGPT.selectedImage)
            })
            .sheet(isPresented: $selectedMonth, content: {
                MonthSelectionView(selectedDate: $currentDate)
                    .presentationDetents([.medium])
            })
            .fullScreenCover(isPresented: $captureImage) {
                AccessCameraView(isPresented: $bindableGPT.isShowingCamera, selectedImage: $bindableGPT.selectedImage)
            }
            .onChange(of: selectedImageItem) { oldItem, newItem in
                loadImage(from: newItem)
            }
            .onChange(of: gpt.selectedImage) { oldValue, newValue in
                DispatchQueue.main.async {
                    gpt.analyze()
                }
            }

        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    gpt.selectedImage = image
                }
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    
}

#Preview {
    IncomeExpenceView()
        .environment(AnalyzingGPT())
}


