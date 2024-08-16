//
//  GPT.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import Foundation
import OpenAI
import SwiftUI
import UIKit
//import Combine


@Observable
class AnalyzingGPT {
    // = Receipts(title: "no value", amount: 0, category: Category.none, date: "no value", marchant: Marchan)
    var result: Receipts? {
        didSet {
            print("레시피 세팅오나료")
        }
    }
    var marchants: [Marchandize] = []
    var analyzed: Bool = true {
        didSet {
            print("값이 왜 바뀌는데:\(self.analyzed)")
        }
    }
    var analyzing: Bool = false
    var isShowingCamera: Bool = false
    var selectedImage: UIImage? 
//    {
//        didSet {
//            Task { @MainActor in
//                guard selectedImage != nil else { return }
//                print("이거👹")
//                analyzed = false  // 초기화가 필요하면 유지
//                self.analyze()     // 분석 시작
//            }
//        }
//    }

    
    init() {
        print("이게 실행된다고?🐶")
    }
    
    var openAI = OpenAI(apiToken: "sk-zz4yHGCwdO-3nIQSa5Q_YbM-RPhHuIuJ1ouzVUqN-qT3BlbkFJF91EyYcFGV4vgEmYib2C9vIxHxMFFgfDIFpESrTjgA")
    
    func reset() {
//        DispatchQueue.main.async {
            self.result = .none
            self.marchants = []
            self.analyzed = false
//            self.isAnalyzing = true
//        }
    }
    
    @MainActor
    func analyze(pressed: Binding<Bool>) {
        reset()

        
        // guard let pngData = imageData.pngData() else { return } // already tried
        guard let jpegData = selectedImage?.jpegData(compressionQuality: 0.1) else { return }
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(jpegData.count))
        print("formatted result: \(string)")
        
        let imageData: Data
        imageData = (selectedImage?.scaleToFit().scaledJPGData())!
        
        
        let imageParam = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.init(
            content:
                .vision([
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .auto)))
                ])
        )
        
        Task {
            do {
                let chatsStream = try await self.openAI.chats(query: ChatQuery(messages: [.user(imageParam)], model: .gpt4_o, tools: tools))
                
                for chat in chatsStream.choices {
                    print("🐱" + (chat.message.toolCalls?.first?.function.arguments.description ?? "아오"))
//                    DispatchQueue.main.async { [self] in
                        for tool in chat.message.toolCalls! {
                            print(tool.function.name + "🐥" + tool.function.arguments.description)
                            guard let arg = tool.function.arguments.data(using: .utf8) else {
                                print("그래그래그래글개ㅡ랙")
                                return
                            }
                            self.analyzed = true
//                            self.isAnalyzing = false
                            
                            switch tool.function.name {
                            case "addExpenseLog" :
                                print("그래그래그래그래그래그래그랙!!!!!!!")
                                self.result = try! JSONDecoder().decode(Receipts.self, from: arg)
                                break
                            case "listExpenses" :
                                print("rfmosdfmasdofmasdofmasdof@!@@@@@@@")
                                let marchant = try! JSONDecoder().decode(Marchandize.self, from: arg)
                                marchants.append(marchant)
                                break
                            default:
                                break
                            }
                        }
                        
                        print("체크포인트11111")
                        print(self.analyzed)
                        print(self.analyzed)
                    pressed.wrappedValue = true
                    }
//                }


            } catch {
                print(error.localizedDescription)
            }
        }
        print(self.analyzed)
    }
    


}

extension UIImage {
    
    func scaleToFit(targetSize: CGSize = .init(width: 512, height: 512)) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: .init(
                origin: .init(
                    x: (targetSize.width - scaledImageSize.width) / 2.0,
                    y: (targetSize.height - scaledImageSize.height) / 2.0),
                size: scaledImageSize))
        }
        return scaledImage
    }
    
    func scaledJPGData(compressionQuality: CGFloat = 0.5) -> Data {
        let targetSize = CGSize(
            width: size.width / UIScreen.main.scale,
            height: size.height / UIScreen.main.scale)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resized = renderer.image { _ in
            self.draw(in: .init(origin: .zero, size: targetSize))
        }
        return resized.jpegData(compressionQuality: compressionQuality)!
    }
    
}
