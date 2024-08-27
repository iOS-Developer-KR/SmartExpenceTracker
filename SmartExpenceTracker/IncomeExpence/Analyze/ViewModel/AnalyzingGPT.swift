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
    var result: Receipts?
    var marchants: [Marchandize] = [Marchandize(price: 1, object: "abc"), Marchandize(price: 2, object: "abc"), Marchandize(price: 3, object: "abc")]
    var analyzed: Bool = true
    var finishAnalyze: Bool = false
    var isShowingCamera: Bool = false
    var selectedImage: UIImage? {
        didSet {
            print("selectedImage setted")
        }
    }
    
    var openAI = OpenAI(apiToken: "sk-zz4yHGCwdO-3nIQSa5Q_YbM-RPhHuIuJ1ouzVUqN-qT3BlbkFJF91EyYcFGV4vgEmYib2C9vIxHxMFFgfDIFpESrTjgA")
    
    func reset() {
            self.result = .none
            self.marchants = []
            self.analyzed = false
    }
    
    @MainActor
    func analyze() {
        reset()
        guard let jpegData = selectedImage?.jpegData(compressionQuality: 0.01) else { return }
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
                    print("🐱" + (chat.message.toolCalls?.first?.function.arguments.description ?? "값없음"))
                        for tool in chat.message.toolCalls! {
                            print(tool.function.name + "🐥" + tool.function.arguments.description)
                            guard let arg = tool.function.arguments.data(using: .utf8) else { return }
                            self.analyzed = true
                            print(arg)
                            switch tool.function.name {
                            case "addExpenseLog" :
                                self.result = try! JSONDecoder().decode(Receipts.self, from: arg)
                                break
                            case "listExpenses" :
                                let marchant = try! JSONDecoder().decode(Marchandize.self, from: arg)
                                marchants.append(marchant)
                                break
                            default:
                                break
                            }
                        }
                        self.finishAnalyze = true
                     

                }
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
