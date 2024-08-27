//
//  MonthSelectionView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/13/24.
//

import SwiftUI


struct MonthSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    var calendar: Calendar = Calendar(identifier: .iso8601)
    var startDate: Date = Date() // 기준 날짜를 설정 (오늘 날짜)
    

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                
                Text("월 선택하기")
                    .font(.title2)
                    .padding(5)
                          
                ForEach(getPreviousMonths(startDate: startDate, toYear: 2018), id: \.self) { date in
                    Button {
                        selectedDate = date
                        dismiss()
                    } label: {
                        HStack {
                            Text(dateToString(date: date, format: "yyyy년 MM월"))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .contentShape(Rectangle())
                                                    .foregroundStyle(Color.primary)
                                                    .padding(5)
                                                Image(systemName: "checkmark")
                                                    .opacity(isSameMonthAndYear(selectedDate, date) ? 1.0 : 0.0)
                                            }
                    }
                    .contentShape(Rectangle())
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
    
    // 두 날짜가 같은 연도와 월인지 확인하는 함수
    func isSameMonthAndYear(_ date1: Date, _ date2: Date) -> Bool {
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)
        return components1.year == components2.year && components1.month == components2.month
    }
    
    
}




#Preview {
    MonthSelectionView(selectedDate: .constant(Date()))
}
