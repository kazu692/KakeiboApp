//
//  AccountBookViewModel.swift
//  KakeiboApp
//　アプリケーションのロジック（支出・収入の追加、合計計算、残高管理など）とデータの管理を行う
//  Created by 山口和也 on 2025/05/27.
//

import Foundation
import Combine // データ変更をViewに通知するために必要
import CoreData

//ObservableObject: Viewに通知可能なオブジェクトであることを示す
class AccountBookViewModel: ObservableObject {
    //@Published: このプロパティの値が変更された時に、それを使用しているViewが自動的に更新される
    //支出
    @Published var expenses: [Expense] = [] {
        // expensesが変更されたら自動的に保存し、全トランザクションを更新する
        didSet {
            updateAllTransactions() // ★修正: expenses が変更されたら allTransactions を再計算
        }
    }
    //収入
    @Published var incomes: [Income] = [] { // 新しく incomes プロパティを追加
        // incomes が変更されたら自動的に保存し、全トランザクションを更新する
        didSet {
            updateAllTransactions()
        }
    }
    //目標貯金額
    @Published var targetSavings: Double = 0.0 {
        didSet {
            saveData() // targetSavings が変更されたら自動的に保存する
        }
    }
    //すべての収支項目を結合し、日付順に並べたもの
    @Published var allTransactions: [TransactionItem] = []
    
    //全支出の合計金額
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    //全収入の合計金額
    var totalIncomes: Double {
        incomes.reduce(0) { $0 + $1.amount }
    }
    //現在の残高
    var balance: Double {
        totalIncomes - totalExpenses
    }
    //貯金の達成度合い
    var savingsProgressPercentage: Double {
        guard targetSavings > 0 else { return 0.0 } // 目標が0以下なら0％
        return min(max(balance / targetSavings, 0.0), 1.0) // 0%から100％に制限
    }
    
    //ViewModelの初期化時にデータを読み込む
    init() {
        loadData() // 保存されたデータを読み込む
        // データの読み込みの後に全トランザクションを更新
        updateAllTransactions() // ★修正: 初期ロード後にも allTransactions を更新

        let hasSavedTarget = UserDefaults.standard.object(forKey: userDefaultsTargetSavingsKey) != nil
        // アプリ初回起動時 (データが全くない場合) にダミーデータを追加
        // ★修正: targetSavings == 0.0 の条件も追加して、より厳密に初回を判断
        if expenses.isEmpty && incomes.isEmpty && !hasSavedTarget {
            print("DEBUG: AccountBookViewModel: 初回起動のためダミーデータを追加します。")
            // ダミー収入
            addIncome(amount: 100000, item: "給料", date: Date()) // 日付も渡すように変更
            addIncome(amount: 5000, item: "お小遣い", date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)

            // ダミー支出
            addExpense(amount: 500, item: "ランチ", date: Date())
            addExpense(amount: 120, item: "お茶", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
            addExpense(amount: 3000, item: "本", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
            
            // 目標貯金額を設定(テスト用)
            targetSavings = 50000.0
            
            // ダミーデータ追加後、手動で saveData と updateAllTransactions を呼び出し
            // (addIncome/addExpense の didSet でも呼ばれるが、確実に初回に反映させるため)
            // ★修正: ここでの明示的な呼び出しは不要、didSetが呼び出すため。
            // saveData() // ← 削除
            // updateAllTransactions() // ← 削除
        }
    }
    
    // MARK: - 追加に関するメソッド
    //支出を追加するメソッド
    // ★修正: 日付も引数に追加（ダミーデータ用）
    func addExpense(amount: Double, item: String, date: Date = Date()){
        let newExpense = Expense(date: date, amount: amount, item: item)
        expenses.append(newExpense)
        // ★修正: 並び替えは updateAllTransactions で行うため、ここから削除
        // expenses.sort { $0.date > $1.date }
    }
    //収入を追加するメソッド
    // ★修正: 日付も引数に追加（ダミーデータ用）
    func addIncome(amount: Double, item: String, date: Date = Date()){
        let newIncome = Income(date: date, amount: amount, item: item)
        incomes.append(newIncome)
        // ★修正: 並び替えは updateAllTransactions で行うため、ここから削除
        // incomes.sort { $0.date > $1.date }
    }
    
    // MARK: - 削除に関するメソッド
    //支出と収入を削除するメソッド
    func deleteTransaction(_ transaction: TransactionItem) {
        switch transaction {
        case .expense(let e):
            if let index = expenses.firstIndex(where: { $0.id == e.id }) {
                expenses.remove(at: index)
            }
        case .income(let i):
            if let index = incomes.firstIndex(where: { $0.id == i.id }) {
                incomes.remove(at: index)
            }
        }
        saveData()
        updateAllTransactions()
    }
    
    //全トランザクションを更新するメソッド
    private func updateAllTransactions(){
        self.allTransactions = expenses.map{TransactionItem.expense($0)} + incomes.map{TransactionItem.income($0)}
        
        self.allTransactions.sort { $0.date > $1.date } // 日付順のソート
        print("DEBUG: allTransactions updated. Count: \(allTransactions.count)")
        // print("DEBUG: allTransactions content: \(allTransactions.map { "\($0.type): \($0.item) - \($0.amount)" })") // 詳細表示（必要ならコメント解除）
    }
    
    // MARK: - データの永続化ロジック
    //UserDefaultsに保存する二つのキー
    private let userDefaultsExpensesKey = "expensesData"
    private let userDefaultsIncomesKey = "incomesData"
    private let userDefaultsTargetSavingsKey = "targetSavingsData"
    
    // 支出データと収入データをまとめてUserDefaultsに保存するメソッド
    private func saveData() {
        //支出の保存
        if let encodedExpenses = try? JSONEncoder().encode(expenses) { // expensesをData型にエンコード
            UserDefaults.standard.set(encodedExpenses, forKey: userDefaultsExpensesKey) // UserDefaultsに保存
            print("DEBUG: 支出データを保存しました。支出数: \(expenses.count)") // デバッグ用
        } else {
            print("ERROR: 支出データのエンコードに失敗しました。") // エラーハンドリング
        }
        
        //収入の保存
        if let encodedIncomes = try? JSONEncoder().encode(incomes) {
            UserDefaults.standard.set(encodedIncomes, forKey: userDefaultsIncomesKey)
            print("DEBUG: 収入データを保存しました。収入数: \(incomes.count)")
        } else {
            print("ERROR: 収入データのエンコードに失敗しました。")
        }
        
        //目標貯金額の保存
        UserDefaults.standard.set(targetSavings, forKey: userDefaultsTargetSavingsKey)
        print("DEBUG: 目標金額を保存しました：\(targetSavings)")
    }
    
    //UserDefaultsから支出と収入データをまとめて読み込むメソッド
    private func loadData() {
        //支出の読み込み
        if let savedExpensesData = UserDefaults.standard.data(forKey: userDefaultsExpensesKey) { // Data型で読み込み
            if let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpensesData) { // Dataから[Expense]にデコード
                self.expenses = decodedExpenses // expensesを更新
                print("DEBUG: 支出データを読み込みました。支出数: \(expenses.count)") // デバッグ用
            } else {
                print("ERROR: 支出データのデコードに失敗しました。") // エラーハンドリング
            }
        } else {
            print("DEBUG: 保存された支出データがありません。") // 初回起動時など
        }
        
        //収入の読み込み
        if let savedIncomesData = UserDefaults.standard.data(forKey: userDefaultsIncomesKey) {
            if let decodedIncomes = try? JSONDecoder().decode([Income].self, from: savedIncomesData) {
                self.incomes = decodedIncomes
                print("DEBUG: 収入データを読み込みました。収入数: \(incomes.count)")
            } else {
                print("ERROR: 収入データのデコードに失敗しました。")
            }
        } else {
            print("DEBUG: 保存された収入データがありません。")
        }
        
        //目標貯金額の読み込み
        self.targetSavings = UserDefaults.standard.double(forKey: userDefaultsTargetSavingsKey)
        print("DEBUG: 目標金額を読み込みました：\(targetSavings)")
    }
}
