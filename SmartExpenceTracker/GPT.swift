//
//  GPT.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import Foundation
import OpenAI

class GPT {
    var openAI = OpenAI(apiToken: "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")
    
    func gptCall() async {
        let functions = [
            ChatQuery.ChatCompletionToolParam(function:
                ChatQuery.ChatCompletionToolParam.FunctionDefinition(
                  name: "get_current_weather",
                  description: "Get the current weather in a given location",
                  parameters:
                    .init(
                      type: .object,
                      properties: [
                        "title": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                        "amount": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                        "category": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                        "date": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                        
                      ],
                      required: ["location"]
                    )
                )
            )
        ]

        let query = ChatQuery(messages: [.user(.init(content: .string(""), name: ""))], model: .gpt3_5Turbo, tools: functions)
//        let query = ChatQuery(
//          model: "gpt-3.5-turbo-0613",  // 0613 is the earliest version with function calls support.
//          messages: [
//              Chat(role: .user, content: "What's the weather like in Boston?")
//          ],
//          functions: functions
//        )
        do {
            let result = try await openAI.chats(query: query)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
