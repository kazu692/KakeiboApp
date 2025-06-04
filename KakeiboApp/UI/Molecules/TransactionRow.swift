//
//  ExpenseRow.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct ExpenseRow: View {
    let expense: Expense // 表示する支出データ

    // 日付フォーマット
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // 短い形式（例: 2023/04/01）
        formatter.timeStyle = .short // 短い形式（例: 10:30）
        return formatter
    }

    var body: some View {
        HStack { // 横方向に要素を配置
            VStack(alignment: .leading) { // 縦方向に要素を配置し、左寄せ
                AppText(text: expense.item, font: .headline) // 項目名
                AppText(text: dateFormatter.string(from: expense.date), font: .caption, color: .gray) // 日付
            }
            Spacer() // 左寄せと右寄せの間隔を自動調整
            AppText(text: "¥" + String(format: "%.0f", expense.amount), font: .subheadline) // 金額（小数点以下なし）
        }
        .padding(.vertical, 4) // 上下のパディング
    }
}

struct ExpenseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(expense: Expense(date: Date(), amount: 1500, item: "カフェ代"))
            .padding()
            .previewLayout(.sizeThatFits) // プレビューのサイズを内容に合わせる
    }
}
