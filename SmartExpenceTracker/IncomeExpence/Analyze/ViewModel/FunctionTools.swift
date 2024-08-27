//
//  FunctionTools.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/16/24.
//

import Foundation
import OpenAI

enum AIAssistantFunctionType: String {
    case addExpenseLog
    case listExpenses
//    case visualizeExpenses
}

let titleProp = (key: "title",
                 value: [
                    "type": "string",
                    "description": "title or description of the expense"
                 ])


typealias PropertyType = ChatQuery.ChatCompletionToolParam.FunctionDefinition.FunctionParameters.Property

let titleProm = PropertyType(type: .string, description: "title or description of the expense")
let amountProm = PropertyType(type: .integer, description: "total payment. If you're not sure, just use USD as default value")
let categoryProm = PropertyType(type: .string, description: "the category of expense. Set category based on the title of expense", enum: Category.allCases.map { $0.rawValue })
let dateProm = PropertyType(type: .string, description: "Date of expense. Set date using of this reciepts information, the date must be formatted yyyy-MM-dd HH:mm")
let objectProm = PropertyType(type: .string, description: "Set the each object name from this reciepts")
let priceProm = PropertyType(type: .integer, description: "Set the each object price from this reciepts. If you're not sure, just use USD as default value")

let tools: [ChatQuery.ChatCompletionToolParam] = [
    ChatQuery.ChatCompletionToolParam(function: .init(
        name: AIAssistantFunctionType.addExpenseLog.rawValue,
        description: "Analyze this Reciepts by given image, and object and prices have to be value of marchant",
        parameters:
                .init(
                    type: .object,
                    properties:
                        [
                        "title": titleProm,
                        "amount": amountProm,
                        "category": categoryProm,
                        "date": dateProm,
                    ]
//                    required: ["title", "amount", "category", "date"]
                )
        )
     ),
    ChatQuery.ChatCompletionToolParam(function: .init(
        name: AIAssistantFunctionType.listExpenses.rawValue,
        description: "Analyze this Reciepts and give me each merchandise info by given image",
        parameters:
                .init(
                    type: .object,
                    properties: [
                        "object": objectProm,
                        "price": priceProm,
                    ]
//                    required: ["object", "price"]
                )
        )
     )
]
