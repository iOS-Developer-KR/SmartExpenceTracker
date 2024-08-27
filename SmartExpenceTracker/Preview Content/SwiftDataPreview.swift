//
//  SwiftDataPreview.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/22/24.
//

import Foundation
import SwiftData

@MainActor
let previewReceiptContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: RecordReceipts.self)
        SampleData.receiptDefaultModel.forEach { receipt in
            container.mainContext.insert(receipt)
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()



struct SampleData {
    static let receiptDefaultModel: [RecordReceipts] = {
        
        let marchants1 = [
            Marchandize(price: 20000, object: "카페"),
            Marchandize(price: 25000, object: "레스토랑"),
            Marchandize(price: 15000, object: "디저트 카페")
        ]

        // 두 번째 marchants 배열
        let marchants2 = [
            Marchandize(price: 30000, object: "영화관"),
            Marchandize(price: 50000, object: "놀이공원"),
            Marchandize(price: 20000, object: "카페")
        ]

        // 세 번째 marchants 배열
        let marchants3 = [
            Marchandize(price: 23000, object: "클라이밍"),
            Marchandize(price: 27000, object: "헬스장"),
            Marchandize(price: 20000, object: "운동용품점")
        ]

        // 각 marchants 배열을 사용하여 RecordReceipts 객체 생성
        let receipt1 = RecordReceipts(
            title: "데이트",
            amount: 60000,
            category: .shopping,
            date: "2024-07-03",
            marchant: marchants1
        )

        let receipt2 = RecordReceipts(
            title: "취미﹒여가",
            amount: 100000,
            category: .none,
            date: "2024-07-04",
            marchant: marchants2
        )

        let receipt3 = RecordReceipts(
            title: "운동",
            amount: 70000,
            category: .otherFinance,
            date: "2024-07-05",
            marchant: marchants3
        )
        return [receipt1,receipt2,receipt3]
    }()
}
