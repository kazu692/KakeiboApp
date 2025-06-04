//
//  Income.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import Foundation

// Identifiable: ForEach でリスト表示するために必要
// Codable: UserDefaults に保存・読み込みするために必要
struct Income: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Double
    let item: String // 給料、お小遣い、副業など
    let type: TransactionType = .income

    init(id: UUID = UUID(), date: Date, amount: Double, item: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.item = item
    }
}
