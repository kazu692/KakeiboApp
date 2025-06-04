//
//  AppTextField.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String // 親Viewと値を共有するためのBinding

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(.systemGray6)) // 背景色
            .cornerRadius(8)
            .autocorrectionDisabled() // 自動修正を無効化
            .textInputAutocapitalization(.never) // 自動大文字化を無効化
    }
}

struct AppTextField_Previews: PreviewProvider {
    @State static var previewText = ""
    static var previews: some View {
        AppTextField(placeholder: "入力してください", text: $previewText)
            .padding()
    }
}
