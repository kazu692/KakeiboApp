//
//  AddExpenseView.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss // モーダルを閉じるための環境変数
    @ObservedObject var viewModel: AccountBookViewModel // 親からViewModelを受け取る
    @State private var amountText: String = ""
    @State private var itemText: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                AddExpenseForm(amountText: $amountText, itemText: $itemText) {
                    // 追加ボタンが押された時のアクション
                    if let amount = Double(amountText), !itemText.isEmpty {
                        viewModel.addExpense(amount: amount, item: itemText)
                        dismiss() // 画面を閉じる
                    } else {
                        alertMessage = "金額と項目を入力してください。"
                        showingAlert = true
                    }
                }
                Spacer()
            }
            .navigationTitle("支出を追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // ナビゲーションバーのボタン
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss() // 画面を閉じる
                    }
                }
            }
            .alert("入力エラー", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(viewModel: AccountBookViewModel())
    }
}
