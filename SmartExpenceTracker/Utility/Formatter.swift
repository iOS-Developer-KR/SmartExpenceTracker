//
//  Formatter.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/27/24.
//

import Foundation

var dateToString: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월"
    formatter.locale = .autoupdatingCurrent
    return formatter
}

func dateToString(date: Date, format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func convertToDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.date(from: string)
}

func convertDateStringToDate(from string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년M월d일"
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.current
    return formatter.date(from: string) ?? Date()
}
