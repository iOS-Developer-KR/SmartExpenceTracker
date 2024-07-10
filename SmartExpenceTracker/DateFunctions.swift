//
//  DateFunctions.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 7/10/24.
//

import Foundation

func convertToDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // 문자열의 형식을 지정
    return formatter.date(from: string)
}
