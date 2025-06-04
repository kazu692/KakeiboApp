//
//  Transaction.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/05/30.
//

import Foundation

// 支出と収入が共通して持つプロパティを定義するプロトコル
protocol Transaction: Identifiable, Codable {
    var id: UUID { get }
    var date: Date { get }
    var amount: Double { get }
    var item: String { get }
    var type: TransactionType { get } // 収入か支出かを区別するためのプロパティ
}

// 収入と支出のタイプを区別するためのEnum
enum TransactionType: String, Codable {
    case income
    case expense
}
