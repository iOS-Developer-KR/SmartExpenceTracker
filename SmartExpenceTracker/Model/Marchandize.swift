//
//  Merchant.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/31/24.
//

import Foundation

struct Marchandize: Codable, Identifiable, Hashable {
    let id: UUID = UUID()
    var price: Int
    var object: String
    
    enum CodingKeys: String, CodingKey {
        case id, price, object
    }
    
    init(price: Int, object: String) {
        self.price = price
        self.object = object
    }

    // 디코딩 시 JSON에 id가 없는 경우 자동으로 UUID를 생성하는 이니셜라이저
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(Int.self, forKey: .price)
        self.object = try container.decode(String.self, forKey: .object)
//        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
    }

    // 인코딩 이니셜라이저
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(price, forKey: .price)
        try container.encode(object, forKey: .object)
//        try container.encode(id, forKey: .id)
    }
}
