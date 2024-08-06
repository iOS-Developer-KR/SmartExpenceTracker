//
//  Receipts.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/31/24.
//

import Foundation


struct Receipts: Codable {
    var title: String
    var amount: Int
    var category: Category
    var date: String
}
