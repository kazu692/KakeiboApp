//
//  AddTransactionForm.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AddTransactionForm: View {
    var title: String
    @Binding var item: String
    @Binding var amount: String
    var onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            AppTextField(placeholder: "項目を入力", text: $item)
            AppTextField(placeholder: "金額を入力", text: $amount)
                .keyboardType(.decimalPad)

            PrimaryButton(title: title) {
                onSubmit()
            }
            .padding(.top)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct AddETransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionForm(
            title: "支出を追加",
            item: .constant("コーヒー"),
            amount: .constant("300"),
            onSubmit: {}
        )
    }
}
