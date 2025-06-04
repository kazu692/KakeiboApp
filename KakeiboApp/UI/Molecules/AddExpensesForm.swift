//
//  AddExpensesForm.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AddExpenseForm: View {
    @Binding var amountText: String
    @Binding var itemText: String
    let addAction: () -> Void // 追加ボタンが押された時のアクション

    var body: some View {
        VStack(spacing: 16) {
            AppTextField(placeholder: "金額", text: $amountText)
                .keyboardType(.decimalPad) // 数値入力キーボード
            AppTextField(placeholder: "項目", text: $itemText)

            AppButton(title: "追加", action: addAction)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct AddExpenseForm_Previews: PreviewProvider {
    @State static var previewAmount = ""
    @State static var previewItem = ""
    static var previews: some View {
        AddExpenseForm(amountText: $previewAmount, itemText: $previewItem) {
            print("プレビューで追加ボタンが押されました")
        }
        .padding()
    }
}
