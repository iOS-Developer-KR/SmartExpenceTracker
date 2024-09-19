//
//  AccessCameraView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/29/24.
//

import Foundation
import SwiftUI


struct AccessCameraView: UIViewControllerRepresentable {

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

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    init(isPresented: Binding<Bool>, selectedImage: Binding<UIImage?>) {
        _isPresented = isPresented
        _selectedImage = selectedImage
    }
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            selectedImage = uiImage
        }
        isPresented = false
        // Dismiss the sheet using the presentingViewController
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    //

}
