//
//  MonthSelectionView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/13/24.
//

import SwiftUI

struct MonthSelectionView: View {
    var calendar: Calendar = Calendar(identifier: .iso8601)
    var startDate: Date = Date() // 기준 날짜를 설정 (오늘 날짜)
    
    // 날짜 포맷터 설정
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월" // 연도와 월 형식 설정
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // 2024년 8월부터 2018년까지 이전 월을 표시
                ForEach(getPreviousMonths(startDate: startDate, toYear: 2018), id: \.self) { date in
                    Text(dateFormatter.string(from: date)) // 날짜를 문자열로 변환하여 표시
                }
            }
            .padding()
        }
    }
    
    // 지정된 연도까지 이전 월들을 반환하는 함수
    func getPreviousMonths(startDate: Date, toYear: Int) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        // 현재 날짜의 연도가 지정된 연도보다 클 때까지 반복
        while calendar.component(.year, from: currentDate) >= toYear {
            dates.append(currentDate)
            
            // 이전 달로 이동
            if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
                currentDate = previousMonth
            } else {
                break // 더 이상 이전 달로 이동할 수 없을 때 중단
            }
        }
        
        return dates
    }
}

#Preview {
    MonthSelectionView()
}
