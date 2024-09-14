//
//  CalculatorView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/23/24.
//

import SwiftUI

enum CalculatorButton: Hashable {
    case digit(String)
    case operation(String)
    case equal
//    case decimal
    case remove
    
    var title: String {
        switch self {
        case .digit(let number):
            return number
        case .operation(let op):
            return op
        case .equal:
            return "="
//        case .decimal:
//            return "."
        case .remove:
            return "←"
        }
    }
}

struct calculatorButtonStyle: ButtonStyle {
    
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Color.primary)
            .frame(width: ((UIWindow.current?.screen.bounds.width)! - 60)/2, height: 50)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(
                withAnimation(.linear, {
                    configuration.isPressed ? 0.96 : 1.0
                })
            )
    }
}


struct CalculatorView: View {
    @Environment(\.dismiss) var dismiss
    @State var displayText: String
    @State private var operation: String? = nil
    
    @Binding var amount: Int
    let buttons: [[CalculatorButton]] = [
        [.digit("7"), .digit("8"), .digit("9"), .operation("-")],
        [.digit("4"), .digit("5"), .digit("6"),.operation("÷")],
        [.digit("1"), .digit("2"), .digit("3"), .operation("×")],
        [ .digit("00"), .digit("0"), .remove, .equal]
    ]
    
    
    var body: some View {
        
        header
        
        calculator
        
        footer
        
    }
    
    @ViewBuilder private var header: some View {
        VStack {
            HStack {
                Text("수정할 금액")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(Color.accentColor)
                Spacer()
            }
            HStack {
                Text("\(displayText)")
                    .font(.title2)
                Spacer()
                Button {
                    displayText = "0"
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.gray)
                }
                Text("원")
                    .font(.title2)
                    .foregroundStyle(Color.primary)
            }
            .padding(3)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var calculator: some View {
        ForEach(buttons, id: \.self) { row in
            HStack(spacing: 10) {
                ForEach(row, id: \.self) { button in
                    Button {
                        buttonTapped(button)
                    } label: {
                        Text(button.title)
                            .font(.title2)
                            .foregroundStyle(Color.primary)
                            .frame(width: ((UIWindow.current?.screen.bounds.width)! - 60)/4.0,
                                   height: ((UIWindow.current?.screen.bounds.width)! - 60)/4.5)
                    }
                }
            }
        }

    }
    
    @ViewBuilder private var footer: some View {
        HStack {
            Button {
                dismiss()
                print("그래")
            } label: {
                Text("닫기")
            }
            .buttonStyle(calculatorButtonStyle(backgroundColor: Color.gray))

            
            Button {
                amount = Int(displayText) ?? amount
                dismiss()
            } label: {
                Text("수정하기")
            }
            .buttonStyle(calculatorButtonStyle(backgroundColor: Color.accentColor))

        }
    }
    
    
    
    // 새로운 값이 들어왔을 때 operation이 없었다면 그냥 더해준다
    // 새로운값이 들어왔을 때 이전값들 중에서 operation이 존재했다면 현재까지 값들과 이전값들과 비교해서 계산을 한다
    
    private func buttonTapped(_ button: CalculatorButton) {
        switch button {
        case .digit(_):
            if displayText == "0" || operation != nil { // 만약 비어있지 않다면
                displayText = button.title
                operation = nil
            } else {
                displayText.append(button.title)
            }
        case .operation(_):
            displayText.append(button.title)
        case .equal:
            performOperation()
//        case .decimal:
//            if !displayText.contains(".") {
//                displayText.append(".")
//            }
        case .remove:
            if displayText.count > 1 {
                displayText.removeLast()
            } else {
                if displayText.count == 1 && displayText != "0" {
                    displayText = "0"
                }
            }
        }
    }
    
    
    // Perform operation
    private func performOperation() {
        var calculatElements: [String] = []
        var currentNumber = ""
        
        // 문자열을 숫자와 연산자로 분리하여 배열에 저장
        for char in displayText {
            if char.isNumber {
                currentNumber.append(char)
            } else {
                if !currentNumber.isEmpty {
                    calculatElements.append(currentNumber)
                    currentNumber = ""
                }
                calculatElements.append(String(char))
            }
        }
        
        // 마지막 숫자를 배열에 추가
        if !currentNumber.isEmpty {
            calculatElements.append(currentNumber)
        }
        
        print(calculatElements)  // ["123", "-", "12", "+", "12343"]
        
        var currentAmount: Int = 0
        var currentOperation: String?
        
        var index = 0
        while index < calculatElements.count {
            let element = calculatElements[index]
            
            if let number = Int(element) {
                if currentOperation == nil {
                    currentAmount = number
                } else {
                    switch currentOperation {
                    case "÷":
                        currentAmount /= number
                    case "×":
                        currentAmount *= number
                    case "-":
                        currentAmount -= number
                    case "+":
                        currentAmount += number
                    default:
                        break
                    }
                    currentOperation = nil
                }
            } else {
                currentOperation = element
            }
            
            index += 1
        }
        displayText = currentAmount.description
    }
}

#Preview {
    CalculatorView(displayText: "0", amount: .constant(3400))
}
