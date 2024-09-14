//
//  IncomeExpenceView.swift
//  SmartExpenceTracker
//
//  Created by Taewon Yoon on 8/3/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct IncomeExpenceView: View {
    
    @Environment(AnalyzingGPT.self) private var gpt
    @Environment(ViewState.self) private var viewState
    @Query var listReceipts: [RecordReceipts]
    
    @State private var currentDate = Date()
    @State private var selectedMonth = false
    @State private var showDialog = false
    @State private var photoPicker = false
    @State private var captureImage = false
    
    @State private var selectedImageItem: PhotosPickerItem?
    
    var body: some View {
        @Bindable var bindableGPT = gpt
        @Bindable var bindableViewState = viewState
        
        VStack {
            DateSelection(currentDate: $currentDate, selected: $selectedMonth)
            balanceSection
            ScrollView {
                
                receiptsList
            }
            Spacer()
        }
        
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: { showDialog.toggle() }) {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .confirmationDialog("Selection", isPresented: $showDialog) {
            Button("사진찍기") { captureImage.toggle() }
            Button("앨범 선택") { photoPicker.toggle() }
        }
        .photosPicker(isPresented: $photoPicker, selection: $selectedImageItem, matching: .images)
        .navigationDestination(for: String.self) { destination in
            if destination == "AnalyzingPhotoView" {
                AnalyzingPhotoView(
                    viewState: viewState,
                    bindableGPT: gpt,
                    selectedImage: $bindableGPT.selectedImage,
                    topTabBarExist: $bindableViewState.topTabBarExist
                )
                .environment(AnalyzingGPT())
                .environment(ViewState())
            }
        }
        .sheet(isPresented: $selectedMonth) {
            MonthSelectionView(selectedDate: $currentDate)
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $captureImage) {
            AccessCameraView(isPresented: $bindableGPT.isShowingCamera, selectedImage: $bindableGPT.selectedImage)
        }
        .onChange(of: selectedImageItem) { _, newItem in
            loadImage(from: newItem)
        }
    }
    
    private var balanceSection: some View {
        let totalAmount = listReceipts
            .filter { receipt in
                let receiptYearMonth = receipt.date.description.prefix(7)
                let currentYearMonth = currentDate.description.prefix(7)
                return receiptYearMonth == currentYearMonth
            }
            .reduce(0) { $0 + $1.amount }
        
        return HStack {
            Text("\(totalAmount)원")
                .padding(.horizontal)
            Spacer()
        }
    }
    
    private var receiptsList: some View {
        ForEach(listReceipts.filter { receipt in
            let receiptYearMonth = receipt.date.description.prefix(7)
            let currentYearMonth = currentDate.description.prefix(7)
            return receiptYearMonth == currentYearMonth
        }, id: \.id) { receipt in
            NavigationLink(destination: IncomeExpenceDetailView(recordReceipts: receipt)
                .environment(AnalyzingGPT())
                .environment(ViewState())
            ) {
                HStack {
                    receipt.category.icon
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(receipt.category.color)
                        .buttonStyle(PressableStyle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(receipt.category.displayName)
                                .foregroundStyle(Color.white)
                            Spacer()
                            Text("\(receipt.amount)원")
                                .foregroundStyle(Color.white)
                        }
                        HStack {
                            Text(receipt.title)
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                            Spacer()
                            Text(receipt.date)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    func trimDateToYearMonth(_ date: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return (components.year!, components.month!)
    }
    
    
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    gpt.selectedImage = image
                    viewState.stack.append("AnalyzingPhotoView")
                    selectedImageItem = nil
                }
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        IncomeExpenceView()
            .environment(AnalyzingGPT())
            .environment(ViewState())
            .modelContainer(previewReceiptContainer)
    }
}
