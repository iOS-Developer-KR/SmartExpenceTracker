//
//  AccessCameraView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/29/24.
//

import Foundation
import SwiftUI


struct AccessCameraView: UIViewControllerRepresentable {
//    @Environment(AnalyzingGPT.self) var gpt
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .camera
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, selectedImage: $selectedImage)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    init(isPresented: Binding<Bool>, selectedImage: Binding<UIImage?>) {
        _isPresented = isPresented
        _selectedImage = selectedImage
    }
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.main.async { [self] in
            if let uiImage = info[.originalImage] as? UIImage {
                selectedImage = uiImage
            }
            isPresented = false
        }
    }
    
}
/*
 동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라마만세
 */
