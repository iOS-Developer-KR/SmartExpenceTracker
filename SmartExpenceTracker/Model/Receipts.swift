//
//  Receipts.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/31/24.
//

import Foundation
import SwiftData

struct Receipts: Codable {
    var title: String = ""
    var amount: Int = 0
    var category: Category = Category.none
    var date: String = ""
    
    init(title: String, amount: Int, category: Category, date: String) {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
    }
  
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        amount = try container.decode(Int.self, forKey: .amount)
        category = try container.decode(Category.self, forKey: .category)
        date = try container.decode(String.self, forKey: .date)
    }

    enum CodingKeys: String, CodingKey {
        case title, amount, category, date
    }
}
