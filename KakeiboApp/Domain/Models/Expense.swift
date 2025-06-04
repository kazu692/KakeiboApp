//
//  Expense.swift
//  KakeiboApp
//　支出を表すデータ構造の定義
//  Created by 山口和也 on 2025/06/04.
//

import Foundation

// Identifiable: ForEachなどでリスト表示する際に、各要素を一意に識別するために必要
// Codable: 将来的にデータを保存・読み込みする際に便利（JSONなどへの変換）
struct Expense: Identifiable, Codable {
    let id : UUID // 各支出項目を一意に識別するためのID
    let date: Date // 支出日
    let amount: Double // 金額
    let item: String // 項目名
    let type: TransactionType = .expense 

    // 便利な初期化メソッド
    init(id: UUID = UUID(),date: Date, amount: Double, item: String) {
        self.id = UUID()
        self.date = date
        self.amount = amount
        self.item = item
    }
}
