//
//  AddTransactionModal.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AddTransactionModal: View {
    @ObservedObject var viewModel: AccountBookViewModel
    var transactionType: TransactionType

    @State private var item: String = ""
    @State private var amount: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            AddTransactionForm(
                title: titleText,
                item: $item,
                amount: $amount,
                onSubmit: handleSubmit
            )
            .navigationTitle(titleText)
            .alert("入力エラー", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("すべての項目を正しく入力してください")
            }
        }
    }

    private var titleText: String {
        transactionType == .expense ? "支出を追加" : "収入を追加"
    }
    private func handleSubmit() {
        guard let amountValue = Double(amount), !item.isEmpty else {
            showAlert = true
            return
        }

        if transactionType == .expense {
            viewModel.addExpense(amount: amountValue, item: item)
        } else {
            viewModel.addIncome(amount: amountValue, item: item)
        }
        dismiss()
    }
}

struct AddTransactionModal_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionModal(viewModel: AccountBookViewModel(), transactionType: .expense)
    }
}
