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

struct Receipts: Codable {
    var title: String
    var amount: Int
    var category: String
    var date: String
}


class GPT: ObservableObject {
    
    @Published var result: Receipts = Receipts(title: "no value", amount: 0, category: "no value", date: "no value")
    @Published var navigate: Bool = false
    var openAI = OpenAI(apiToken: "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")
    var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await addSubscriber()
        }
    }
    
    @MainActor
    func analyze(imageData: Data, value: Binding<Bool>) {
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
        
        print("analysing2")
        let imageParam = ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam.init(
            content:
                .vision([
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .high)))
                ])
        )
        
        Task {
            do {
                let chatsStream = try await openAI.chats(query: ChatQuery(messages: [.user(imageParam)], model: .gpt4_o, tools: functions))
                for chat in chatsStream.choices {
                    print(chat.message.toolCalls?.first?.function.arguments.description)
                    if let arg = chat.message.toolCalls?.first?.function.arguments.data(using: .utf8) {
                        DispatchQueue.main.async { [self] in
                            self.result = try! JSONDecoder().decode(Receipts.self, from: arg)
                            print("해독한 json" + self.result.category + self.result.date + result.title)
                        }
                    } else {
                        print("no data")
                    }
                }
                print("")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func addSubscriber() {
        $result
            .sink { [weak self] receipts in
                if receipts.amount == 0 {
                    self?.navigate = false
                } else {
                    self?.navigate = true
                }
            }
            .store(in: &cancellables)
    }

}


//extension Binding where Value == Bool {
//    
//    init<T>(value: Binding<T?>) {
//        self.init {
//            value.wrappedValue != nil
//        } set: { newValue in
//            if !newValue {
//                value.wrappedValue = nil
//            }
//        }
//    }
//}

/*
 func gptCall() async {
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
 */
