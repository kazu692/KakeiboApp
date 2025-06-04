//
//  TransactionItem.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/04.
//

import Foundation

/// 支出と収入を1つの型として扱うためのラッパー型（列挙型）
enum TransactionItem: Identifiable, Codable {
    case expense(Expense)
    case income(Income)

    var id: UUID {
        switch self {
        case .expense(let e): return e.id
        case .income(let i): return i.id
        }
    }

    var date: Date {
        switch self {
        case .expense(let e): return e.date
        case .income(let i): return i.date
        }
    }

    var amount: Double {
        switch self {
        case .expense(let e): return e.amount
        case .income(let i): return i.amount
        }
    }

    var item: String {
        switch self {
        case .expense(let e): return e.item
        case .income(let i): return i.item
        }
    }

    var type: TransactionType {
        switch self {
        case .expense: return .expense
        case .income: return .income
        }
    }
}

// MARK: - Equatable も必要なら追加（任意）

extension TransactionItem: Equatable {
    static func == (lhs: TransactionItem, rhs: TransactionItem) -> Bool {
        return lhs.id == rhs.id
    }
}
