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
    var title: String = ""
    var amount: Int = 0
    var category: Category = Category.none
    var date: String = ""
//    var marchant: Marchandize
    
    init(title: String, amount: Int, category: Category, date: String/*, marchant: Marchandize*/) {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
//        self.marchant = marchant
    }
  
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
//        try container.encode(marchant, forKey: .marchant)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        amount = try container.decode(Int.self, forKey: .amount)
        category = try container.decode(Category.self, forKey: .category)
        date = try container.decode(String.self, forKey: .date)
//        marchant = try container.decode(Marchandize.self, forKey: .marchant)
    }

    enum CodingKeys: String, CodingKey {
        case title, amount, category, date//, marchant
    }
}
