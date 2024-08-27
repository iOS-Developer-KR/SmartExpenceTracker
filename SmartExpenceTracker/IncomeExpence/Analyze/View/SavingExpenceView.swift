import SwiftUI
import SwiftData

struct SavingExpenceView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var dbContext
    var viewState: ViewState
    
    @Bindable var gpt: AnalyzingGPT
    
    var body: some View {
        headerSection
        Divider()
        
        contentSection
        Spacer()
    
            .onTapGesture {
                hideKeyboard()
            }
        
    }
    
    @ViewBuilder private var headerSection: some View {
        HStack {
            Button(action: dismissView) {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.red)
            }
            .padding()

            Spacer()
            Button(action: saveExpense) {
                Text("Save")
            }
            .padding()
        }
    }
    
    @ViewBuilder private var contentSection: some View {
        VStack(spacing: 10) {
            dateSection
            Divider()
            categorySection
            Divider()
            titleSection
            Divider()
            marchantsSection
            Divider()
            amountSection
        }
    }
    
    @ViewBuilder private var dateSection: some View {
        HStack {
            DatePicker("날짜", selection: .constant(convertToDate(from: gpt.result?.date ?? "") ?? Date()), displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)
                
            Spacer()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private var categorySection: some View {
        labeledSection(title: "카테고리", value: gpt.result?.category.displayName ?? "알수없음", icon: gpt.result?.category.icon)
    }
    
    @ViewBuilder private var titleSection: some View {
        labeledSection(title: "구매내역", value: gpt.result?.title ?? "알수없음")
    }
    
    
    @ViewBuilder private var marchantsSection: some View {
        ScrollView {
            VStack {
                ForEach($gpt.marchants) { $mar in
                        VStack {
                            label(title: "상품명", value: $mar.object)
                            label(title: "가격", value: $mar.price)
                        }
                }
                Spacer()
            }
        }
    }

    
    @ViewBuilder private var amountSection: some View {
        labeledSection(title: "Amount", value: "\(gpt.result?.amount ?? 0)")
    }
    
    private func label<T>(title: String, value: Binding<T>) -> some View where T: CustomStringConvertible, T: LosslessStringConvertible {
        HStack {
            Text(title)
                .frame(width: 50)
            
            TextField("\(value.wrappedValue)원", text: Binding(
                get: { title=="가격" ? "\(value.wrappedValue) 원" : "\(value.wrappedValue)" },
                set: { newValue in
                    if let convertedValue = T(newValue) {
                        value.wrappedValue = convertedValue
                    }
                }
            ))
            .keyboardType(T.self == Int.self ? .decimalPad : .default)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 3)
    }

    
    
    @ViewBuilder private func labeledSection(title: String, value: String, icon: Image? = nil) -> some View {
        HStack {
            Text(title)
            Spacer()
            if let icon = icon {
                icon
            }
            Text(value)
        }
        .padding(.horizontal)
        .padding(.vertical, 3)
    }
    
    
    private func dismissView() {
        dismiss()
    }
    
    private func saveExpense() {
        if let title = gpt.result?.title, let amount = gpt.result?.amount, let category = gpt.result?.category, let date = gpt.result?.date {
            let newReceipts = RecordReceipts(title: title, amount: amount, category: category, date: date, marchant: gpt.marchants)
            dbContext.insert(newReceipts)
            viewState.stack = .init()
        }
        dismiss()
    }
}

#Preview {
    SavingExpenceView(viewState: ViewState(), gpt: AnalyzingGPT())
        .environment(AnalyzingGPT())
        .environment(ViewState())
}



// Function to hide the keyboard
private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()
