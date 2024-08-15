//
//  Receipts.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/31/24.
//

import Foundation
import SwiftData

@Model
class Receipts: Codable {
    var title: String
    var amount: Int
    var category: Category
    var date: String
    
    init(title: String, amount: Int, category: Category, date: String) {
//        self.id = id
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
    }

    // Implementing the Encodable protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
    }
    
    // Implementing the Decodable protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        amount = try container.decode(Int.self, forKey: .amount)
        category = try container.decode(Category.self, forKey: .category)
        date = try container.decode(String.self, forKey: .date)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, amount, category, date
    }
}
