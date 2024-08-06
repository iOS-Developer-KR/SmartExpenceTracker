//
//  Category.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/6/24.
//

import Foundation
import SwiftUI

enum Category: String, CaseIterable, Codable {
    case none = "카테고리 없음"
    case transfer = "이체"
    case shopping = "쇼핑"
    case transport = "교통 자동차"
    case cafe = "카페 간식"
    case convenienceStore = "편의점 마트 잡화"
    case insuranceTax = "보험금 세금"
    case otherFinance = "기타 금융"

    var displayName: String {
            switch self {
            case .none:
                return "카테고리 없음"
            case .transfer:
                return "이체"
            case .shopping:
                return "쇼핑"
            case .transport:
                return "교통 자동차"
            case .cafe:
                return "카페 간식"
            case .convenienceStore:
                return "편의점 마트 잡화"
            case .insuranceTax:
                return "보험금 세금"
            case .otherFinance:
                return "기타 금융"
            }
        }

        var icon: Image {
            switch self {
            case .none:
                return Image(systemName: "questionmark.circle")
            case .transfer:
                return Image(systemName: "arrow.left.arrow.right")
            case .shopping:
                return Image(systemName: "cart")
            case .transport:
                return Image(systemName: "car")
            case .cafe:
                return Image(systemName: "cup.and.saucer")
            case .convenienceStore:
                return Image(systemName: "bag")
            case .insuranceTax:
                return Image(systemName: "doc.text")
            case .otherFinance:
                return Image(systemName: "creditcard")
            }
        }
}
