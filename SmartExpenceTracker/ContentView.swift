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
    @State private var item: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Image(uiImage: UIImage(named: "japan1")!)
                .resizable()
            
        }
        .padding()
        .task {
//            await gpt.gptCall()
        }
    }
}

#Preview {
    ContentView()
        .environment(GPT())
}
