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

struct Marchandize: Codable, Identifiable {
    var id = UUID()
    var price: Int
    var object: String
    
    enum CodingKeys: String, CodingKey {
        case id, price, object
    }

    // 디코딩 시 JSON에 id가 없는 경우 자동으로 UUID를 생성하는 이니셜라이저
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(Int.self, forKey: .price)
        self.object = try container.decode(String.self, forKey: .object)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
    }

    // 인코딩 이니셜라이저
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(price, forKey: .price)
        try container.encode(object, forKey: .object)
        try container.encode(id, forKey: .id)
    }
}


class GPT: ObservableObject {
    
    @Published var result: Receipts = Receipts(title: "no value", amount: 0, category: "no value", date: "no value")
    @Published var marchants: [Marchandize] = []
    @Published var navigate: Bool = false
    var openAI = OpenAI(apiToken: "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")
    var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            addSubscriber()
        }
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.result = .init(title: "", amount: 0, category: "", date: "")
            self.marchants = []
            self.navigate = false
        }
    }
    
    @MainActor
    func analyze(imageData: Data) {//, value: Binding<Bool>) {
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
                                "category": .init(type: .string, description: "the category of expense. Set category based on the title of expense"),
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
                    for tool in chat.message.toolCalls! {
                        print(tool.function.arguments.description)
                    }

                    if let toolcalls = chat.message.toolCalls, let arg = toolcalls.first?.function.arguments.data(using: .utf8) {
                        DispatchQueue.main.async { [self] in
                            self.result = try! JSONDecoder().decode(Receipts.self, from: arg)
                            print("해독한 json" + self.result.category + self.result.date + result.title)
                            
                            
                            for tool in toolcalls.dropFirst() {
                                if let arg = tool.function.arguments.data(using: .utf8) {
                                    let marchant = try! JSONDecoder().decode(Marchandize.self, from: arg)
                                    marchants.append(marchant)
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    //marchants

                }
                print("")
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
