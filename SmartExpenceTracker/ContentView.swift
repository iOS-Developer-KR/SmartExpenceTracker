//
//  ContentView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var item: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            PhotosPicker(selection: $item) {
                
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
