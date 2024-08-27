//
//  Formatter.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/27/24.
//

import Foundation

// 날짜 포맷터 설정
var dateToString: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY MM dd일 hh시 mm분" // 연도와 월 형식 설정
    return formatter
}

func convertToDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm" // 문자열의 형식을 지정
    return formatter.date(from: string)
}



func convertToMonthDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM" // 문자열의 형식을 지정
    return formatter.date(from: string)
}

//func convertToMonthDate(from date: Date) -> Date? {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM" // 문자열의 형식을 지정
//    return formatter.date(from: <#T##String#>)
//}
