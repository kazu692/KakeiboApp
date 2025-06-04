//
//  AccountBookViewModel.swift // ファイル名も変更することをお勧めします
//  KakeiboApp
//　アプリケーションのロジック（支出・収入の追加、合計計算、残高管理など）とデータの管理を行う
//  Created by 山口和也 on 2025/05/27.
//

import Foundation
import Combine//データ変更をViewに通知するために必要

//ObservableObject: Viewに通知可能なオブジェクトであることを示す
class AccountBookViewModel: ObservableObject { // ここを AccountBookViewModel に変更
    
    //@Published: このプロパティの値が変更された時に、それを使用しているViewが自動的に更新される
    @Published var expenses: [Expense] = [] {
        didSet {
            saveData() // expenses が変更されたら自動的に保存する
        }
    }
    
    @Published var incomes: [Income] = [] { // 新しく incomes プロパティを追加
        didSet {
            saveData() // incomes が変更されたら自動的に保存する
        }
    }
    
    //全支出の合計金額
    var totalExpenses: Double { // totalAmount を totalExpenses にリネーム
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    //全収入の合計金額 (新しく追加)
    var totalIncomes: Double {
        incomes.reduce(0) { $0 + $1.amount }
    }
    
    //現在の残高 (新しく追加)
    var balance: Double {
        totalIncomes - totalExpenses
    }
    
    // ViewModelの初期化時にデータを読み込む
    init(){
        loadData() // 保存されたデータを読み込む

        // 読み込んだデータが空の場合、最初のダミーデータが欲しいなら以下を追加
        if expenses.isEmpty && incomes.isEmpty {
            // ダミーの収入と支出を追加
            addIncome(amount: 100000, item: "給料")
            addExpense(amount: 500, item: "ランチ")
            addExpense(amount: 120, item: "お茶")
            addExpense(amount: 3000, item: "本")
            addIncome(amount: 5000, item: "お小遣い")
        }
    }
    
    //支出を追加するメソッド
    func addExpense(amount: Double, item: String){
        let newExpense = Expense(date: Date(), amount: amount, item: item)
        expenses.append(newExpense)
        //並び替え（日付が新しいものが上に来るように）
        expenses.sort { $0.date > $1.date }
    }

    //収入を追加するメソッド (新しく追加)
    func addIncome(amount: Double, item: String) {
        let newIncome = Income(date: Date(), amount: amount, item: item)
        incomes.append(newIncome)
        // 並び替え（日付が新しいものが上に来るように）
        incomes.sort { $0.date > $1.date }
    }
    
    // MARK: - データ永続化のロジック
    // UserDefaults に保存するキーを2つに分ける
    private let userDefaultsExpensesKey = "expensesData"
    private let userDefaultsIncomesKey = "incomesData"

    // 支出と収入データをまとめてUserDefaultsに保存するメソッド
    private func saveData() {
        // 支出の保存
        if let encodedExpenses = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encodedExpenses, forKey: userDefaultsExpensesKey)
            print("支出データを保存しました。")
        } else {
            print("支出データのエンコードに失敗しました。")
        }

        // 収入の保存
        if let encodedIncomes = try? JSONEncoder().encode(incomes) {
            UserDefaults.standard.set(encodedIncomes, forKey: userDefaultsIncomesKey)
            print("収入データを保存しました。")
        } else {
            print("収入データのエンコードに失敗しました。")
        }
    }

    // UserDefaultsから支出と収入データをまとめて読み込むメソッド
    private func loadData() {
        // 支出の読み込み
        if let savedExpensesData = UserDefaults.standard.data(forKey: userDefaultsExpensesKey) {
            if let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpensesData) {
                self.expenses = decodedExpenses
                print("支出データを読み込みました。")
            } else {
                print("支出データのデコードに失敗しました。")
            }
        } else {
            print("保存された支出データがありません。")
        }

        // 収入の読み込み
        if let savedIncomesData = UserDefaults.standard.data(forKey: userDefaultsIncomesKey) {
            if let decodedIncomes = try? JSONDecoder().decode([Income].self, from: savedIncomesData) {
                self.incomes = decodedIncomes
                print("収入データを読み込みました。")
            } else {
                print("収入データのデコードに失敗しました。")
            }
        } else {
            print("保存された収入データがありません。")
        }
    }
    
    // (Optional) 支出を削除するメソッド (変更なし)
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }

    // (Optional) 収入を削除するメソッド (新しく追加)
    func deleteIncome(at offsets: IndexSet) {
        incomes.remove(atOffsets: offsets)
    }
}
