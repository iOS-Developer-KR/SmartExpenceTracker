//
//  GPT.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import Foundation
import OpenAI
import SwiftUI

struct Receipts: Codable {
    var title: String
    var amount: Int
    var category: String
    var date: String
}

@Observable
class GPT {
    var openAI = OpenAI(apiToken: "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")
    
    func gptCall() async {
        print("흠")
        let functions = [
            ChatQuery.ChatCompletionToolParam(function: .init(
                name: "Analysing-Given-Reciepts",
                description: "Analyze this Reciepts by given image",
                parameters:
                        .init(
                            type: .object,
                            properties: [
                                "title": .init(type: .string, description: "Set the title of this reciepts"),
                                "amount": .init(type: .integer, description: "total payment. If you're not sure, just use USD as default value"),
                                "category": .init(type: .string, description: "the category of expense. Set category based on the title of expense"),
                                "date": .init(type: .string, description: "Date of expense. Set date using of this reciepts information, the date must be formatted yyy-MM-dd")
                            ],
                            required: ["title", "amount", "category"]
                        )
                )
             )
        ]

        if let image = UIImage(named: "japan1"), let imageData = image.jpegData(compressionQuality: 1.0) {
            let imageParam = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.init(
                content: 
                    .vision([
                        .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .high)))
                    ])
            )
            
            do {
                let chatsStream = try await openAI.chats(query: ChatQuery(messages: [.user(imageParam)], model: .gpt4_o, tools: functions))
                for chat in chatsStream.choices {
                    if let arg = chat.message.toolCalls?.first?.function.arguments.data(using: .utf8), let decoded = try? JSONDecoder().decode(Receipts.self, from: arg) {
                        print("해독한 json" + decoded.category + decoded.date + decoded.title)
                    }
                    
                }
            } catch {
                print(error.localizedDescription)
            }
            


        } else {
            print("else문")
        }
        
        

    }
}
