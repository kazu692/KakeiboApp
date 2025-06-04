//
//  AppButton.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AppButton: View {
    let title: String
    let action: () -> Void // ボタンが押された時に実行されるクロージャ

    var body: some View {
        Button(action: action) {
            AppText(text: title, color: .white)
                .frame(maxWidth: .infinity) // 横幅いっぱいに広げる
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(title: "タップしてください") {
            print("ボタンがタップされました！")
        }
        .padding()
    }
}
