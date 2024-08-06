//
//  GPT.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/7/24.
//

import Foundation
import OpenAI
import SwiftUI
import Combine


class AnalyzingGPT: ObservableObject {
    
    @Published var result: Receipts = Receipts(title: "no value", amount: 0, category: Category.none, date: "no value")
    @Published var marchants: [Marchandize] = []
    @Published var navigate: Bool = false
    var openAI = OpenAI(apiToken: "sk-zz4yHGCwdO-3nIQSa5Q_YbM-RPhHuIuJ1ouzVUqN-qT3BlbkFJF91EyYcFGV4vgEmYib2C9vIxHxMFFgfDIFpESrTjgA")
    var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            addSubscriber()
        }
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.result = .init(title: "", amount: 0, category: Category.none, date: "")
            self.marchants = []
            self.navigate = false
        }
    }
    
    @MainActor
    func analyze(imageData: Data) {
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
        
        print(imageData.description)
        
        
        let imageParam = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.init(
            content:
                .vision([
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .high)))
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
    
    func addSubscriber() {
        $result
            .sink { [weak self] receipts in
                DispatchQueue.main.async {
                    if receipts.amount == 0 {
                        self?.navigate = false
                    } else {
                        self?.navigate = true
                    }
                }
            }
            .store(in: &cancellables)
    }

}
