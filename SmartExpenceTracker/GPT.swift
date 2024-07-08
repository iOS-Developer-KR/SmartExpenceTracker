//
//  GPT.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import Foundation
import OpenAI
import UIKit

class GPT {
    var openAI = OpenAI(apiToken: "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")
    
    func gptCall() async {
        let functions = [
            ChatQuery.ChatCompletionToolParam(function:
                ChatQuery.ChatCompletionToolParam.FunctionDefinition(
                    name: "Analysing Reciepts",
                    description: "Analyze this Reciepts by given image",
                    parameters:
                            .init(
                                type: .object,
                                properties: [
                                    "title": .init(type: .string, description: "Set the title of this reciepts"),
                                    "amount": .init(type: .string, description: "Set amount of total payment "),
                                    "category": .init(type: .string, description: "Set category of this reciepts"),
                                    "date": .init(type: .string, description: "Set date using of this reciepts information")
                                ],
                                required: ["title", "amount", "category", "date"]
                            )
                )
             )
        ]
        
        //        let query = ChatQuery(messages: [.init(role: .tool, content: )], model: <#T##Model#>)
        
        if let image = UIImage(named: "curly_1"), let imageData = image.jpegData(compressionQuality: 1.0) {
            let base64String = imageData.base64EncodedString()
            let imageUrl = "data:image/jpeg;base64,\(base64String)"
            let imageParam = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.init(content: .string(imageUrl))
            
            let query = ChatQuery(messages: [.user(imageParam)], model: .gpt3_5Turbo, tools: functions)

            do {
                let result = try await openAI.chats(query: query)
                print(result.choices.first?.message.content?.string ?? "값 없음")
            } catch {
                debugPrint(error.localizedDescription)
            }
            //                   messages.append(.user(imageParam))
        }
        
        

    }
}
