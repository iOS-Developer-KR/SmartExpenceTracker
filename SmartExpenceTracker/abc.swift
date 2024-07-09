//
//  abc.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/9/24.
//

import SwiftUI

struct abc: View {
    @State private var isOpaque = false
    @State private var isOffset = false

    var body: some View {
        ZStack {
            GeometryReader(content: { geometry in
                Image(uiImage: UIImage(named: "japan1")!)
                    .resizable()
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 400, height: 5)
                    .opacity(isOpaque ? 0.3 : 0.8)
                    .offset(y: isOffset ? 0 : (UIScreen.current?.bounds.height)! - 80)
                    .overlay(
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 400, height: 50)
                            .opacity(isOpaque ? 0.3 : 0.8)
                            .offset(y: isOffset ? 0 : (UIScreen.current?.bounds.height)! - 100)
                    )
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isOpaque.toggle()
                        }
                        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            isOffset.toggle()
                        }
                    }
                    

            })
            
            
        }
    }
}

#Preview {
    abc()
}
