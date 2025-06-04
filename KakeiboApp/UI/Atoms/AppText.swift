//
//  AppText.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct AppText: View {
    let text: String
    var font: Font = .body // デフォルトのフォント
    var color: Color = .primary // デフォルトの文字色

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color)
    }
}

struct AppText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AppText(text: "Hello, World!")
            AppText(text: "Large Title", font: .largeTitle, color: .blue)
            AppText(text: "Caption", font: .caption, color: .gray)
        }
    }
}
