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

//public typealias ReceiptImage = NSImage
@Observable
class AnalyzingGPT {
    
    var result: Receipts = Receipts(title: "no value", amount: 0, category: Category.none, date: "no value")
    var marchants: [Marchandize] = []
    var navigate: Bool = false
    var isShowingCamera: Bool = false
    var selectedImage: UIImage?
    
    var openAI = OpenAI(apiToken: "sk-zz4yHGCwdO-3nIQSa5Q_YbM-RPhHuIuJ1ouzVUqN-qT3BlbkFJF91EyYcFGV4vgEmYib2C9vIxHxMFFgfDIFpESrTjgA")
    
    func reset() {
        DispatchQueue.main.async {
            self.result = .init(title: "", amount: 0, category: Category.none, date: "")
            self.marchants = []
            self.navigate = false
        }
    }
    @MainActor
    func analyzeData(imageData: Data) {
        reset()
        let functions = [
            ChatQuery.ChatCompletionToolParam(function: .init(
                name: "Analysing-Given-Reciepts",
                description: "Analyze this Reciepts by given image",
                parameters:
                        .init(
                            type: .object,
                            properties: [
                                "title": .init(type: .string, description: "Set the simple title of this reciepts"),
                                "amount": .init(type: .integer, description: "total payment. If you're not sure, just use USD as default value"),
                                "category": .init(type: .string, description: "the category of expense. Set category based on the title of expense", enum: Category.allCases.map { $0.rawValue }),
                                "date": .init(type: .string, description: "Date of expense. Set date using of this reciepts information, the date must be formatted yyy-MM-dd")
                            ],
                            required: ["title", "amount", "category"]
                        )
                )
             ),
            ChatQuery.ChatCompletionToolParam(function: .init(
                name: "Analysing-Given-Reciepts",
                description: "Analyze this Reciepts and give me each merchandise info by given image",
                parameters:
                        .init(
                            type: .object,
                            properties: [
                                "object": .init(type: .string, description: "Set the each object name from this reciepts"),
                                "price": .init(type: .integer, description: "Set the each object price from this reciepts. If you're not sure, just use USD as default value"),
                            ],
                            required: ["object", "price"]
                        )
                )
             )
        ]
        
        let imageParam = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.init(
            content:
                .vision([
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .auto)))
                ])
        )
        
        Task {
            do {
                let chatsStream = try await self.openAI.chats(query: ChatQuery(messages: [.user(imageParam)], model: .gpt4_o, tools: functions))
                for chat in chatsStream.choices {
                    for tool in chat.message.toolCalls! {
                        print(tool.function.arguments.description)
                    }

                    if let toolcalls = chat.message.toolCalls, let arg = toolcalls.first?.function.arguments.data(using: .utf8) {
                        DispatchQueue.main.async { [self] in
                            print(arg)
                            self.result = try! JSONDecoder().decode(Receipts.self, from: arg)
                            print("해독한 json" + self.result.category.displayName + self.result.date + result.title)
                            
                            
                            for tool in toolcalls.dropFirst() {
                                if let arg = tool.function.arguments.data(using: .utf8) {
                                    let marchant = try! JSONDecoder().decode(Marchandize.self, from: arg)
                                    marchants.append(marchant)
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func analyze() {
        reset()
        let functions = [
            ChatQuery.ChatCompletionToolParam(function: .init(
                name: "Analysing-Given-Reciepts",
                description: "Analyze this Reciepts by given image",
                parameters:
                        .init(
                            type: .object,
                            properties: [
                                "title": .init(type: .string, description: "Set the simple title of this reciepts"),
                                "amount": .init(type: .integer, description: "total payment. If you're not sure, just use USD as default value"),
                                "category": .init(type: .string, description: "the category of expense. Set category based on the title of expense", enum: Category.allCases.map { $0.rawValue }),
                                "date": .init(type: .string, description: "Date of expense. Set date using of this reciepts information, the date must be formatted yyy-MM-dd")
                            ],
                            required: ["title", "amount", "category"]
                        )
                )
             ),
            ChatQuery.ChatCompletionToolParam(function: .init(
                name: "Analysing-Given-Reciepts",
                description: "Analyze this Reciepts and give me each merchandise info by given image",
                parameters:
                        .init(
                            type: .object,
                            properties: [
                                "object": .init(type: .string, description: "Set the each object name from this reciepts"),
                                "price": .init(type: .integer, description: "Set the each object price from this reciepts. If you're not sure, just use USD as default value"),
                            ],
                            required: ["object", "price"]
                        )
                )
             )
        ]
        
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
                let chatsStream = try await self.openAI.chats(query: ChatQuery(messages: [.user(imageParam)], model: .gpt4_o, tools: functions))
                for chat in chatsStream.choices {
                    for tool in chat.message.toolCalls! {
                        print(tool.function.arguments.description)
                    }

                    if let toolcalls = chat.message.toolCalls, let arg = toolcalls.first?.function.arguments.data(using: .utf8) {
                        DispatchQueue.main.async { [self] in
                            print("가져온 데이터:\(arg)")
                            self.result = try! JSONDecoder().decode(Receipts.self, from: arg)
                            if result.amount == 0 {
                                self.navigate = false
                            } else {
                                self.navigate = true
                            }
                            print("해독한 json" + self.result.category.displayName + self.result.date + result.title)
                            
                            
                            for tool in toolcalls.dropFirst() {
                                if let arg = tool.function.arguments.data(using: .utf8) {
                                    let marchant = try! JSONDecoder().decode(Marchandize.self, from: arg)
                                    marchants.append(marchant)
                                }
                                
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
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
