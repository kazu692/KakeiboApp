//
//  AddIncomeView.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/05/29. // 作成日を今日の日付に
//

import SwiftUI

struct AddIncomeView: View {
    @Environment(\.dismiss) var dismiss // モーダルを閉じるための環境変数
    @ObservedObject var viewModel: AccountBookViewModel // AccountBookViewModel を受け取る
    
    @State private var amountText: String = ""
    @State private var itemText: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // AddExpenseForm と同じように、金額と項目を入力するフォームを使用
                // アクションブロックで viewModel.addIncome を呼び出す
                AddExpenseForm(amountText: $amountText, itemText: $itemText) {
                    // 追加ボタンが押された時のアクション
                    if let amount = Double(amountText), !itemText.isEmpty {
                        viewModel.addIncome(amount: amount, item: itemText) // ここを addIncome に変更
                        dismiss() // 画面を閉じる
                    } else {
                        alertMessage = "金額と項目を入力してください。"
                        showingAlert = true
                    }
                }
                Spacer()
            }
            .navigationTitle("収入を追加") // ナビゲーションタイトルを変更
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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

struct AddIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        // ViewModel のインスタンスをプレビューに渡す
        AddIncomeView(viewModel: AccountBookViewModel())
    }
}
