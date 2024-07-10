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
    @State private var showDialog: Bool = false
    @State private var photopicker: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("")
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
                    AnalyzingPhotoView(selectedImageItem: selectedImageItem)
                        .onAppear {
                            self.selectedImageItem = .none
                        }
                }
            })
            .photosPicker(isPresented: $photopicker, selection: $selectedImageItem, matching: .images)
        }
    }
}

#Preview {
    ContentView()
}
