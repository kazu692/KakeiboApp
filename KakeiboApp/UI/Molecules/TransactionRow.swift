//
//  TransactionRow.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                AppText(text: transaction.item, font: .headline)
                AppText(text: formattedDate, font: .caption, color: .gray)
            }
            Spacer()
            AppText(
                text: "\(transaction.type == .income ? "+" : "-")\(String(format: "%.0f", transaction.amount)) 円",
                font: .subheadline,
                color: transaction.type == .income ? .green : .red
            )
        }
        .padding(.vertical, 4)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: transaction.date)
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: TransactionItem.income(
            Income(date: Date(), amount: 5000, item: "アルバイト")
        ))
    }
}
