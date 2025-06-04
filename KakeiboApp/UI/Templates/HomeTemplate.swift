//
//  ContentView.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/05/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AccountBookViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 残高と目標表示
                // 円グラフと残高・目標を横並びで表示
                HStack(alignment: .center, spacing: 16) {
                    Spacer(minLength: 0)
                    VStack{
                        Spacer()
                        SavingsProgressRingView(
                            progress: viewModel.savingsProgressPercentage,
                            thickness: 15,
                            accentColor: .green,
                            backgroundColor: .gray.opacity(0.3)
                        )
                        .frame(width: 120, height: 120)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.4)

                    VStack(alignment: .leading, spacing: 8) {
                        AppText(text: "現在の残高", font: .headline)
                        AppText(text: "\(Int(viewModel.balance)) 円", font: .title, color: .blue)
                        AppText(text: "目標: \(Int(viewModel.targetSavings)) 円", font: .headline, color: .gray)
                        AppButton(title: "目標を設定") {
                            showSetTargetView.toggle()
                        }
                        .scaleEffect(0.65)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()

                // 最近の収支
                
                List {
                    Section(header: AppText(text: "最近の収支", font: .headline)) {
                        ForEach(viewModel.allTransactions.prefix(10)) { transaction in
                            HStack {
                                VStack(alignment: .leading) {
                                    AppText(text: transaction.item, font: .headline)
                                    AppText(text: dateFormatter.string(from: transaction.date), font: .caption, color: .gray)
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
                        .onDelete { indexSet in
                            for index in indexSet {
                                let transaction = viewModel.allTransactions[index]
                                viewModel.deleteTransaction(transaction)
                            }
                        }
                    }
                }

                // ボタン群
                HStack(spacing: 12) {
                    AppButton(title: "支出を追加") {
                        showAddExpenseView.toggle()
                    }
                    AppButton(title: "収入を追加") {
                        showAddIncomeView.toggle()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("家計簿")
        }
        .sheet(isPresented: $showAddExpenseView) {
            AddExpenseView(viewModel: viewModel)
        }
        .sheet(isPresented: $showAddIncomeView) {
            AddIncomeView(viewModel: viewModel)
        }
        .sheet(isPresented: $showSetTargetView) {
            SetTargetSavingsView(viewModel: viewModel)
        }
    }

    @State private var showAddExpenseView = false
    @State private var showAddIncomeView = false
    @State private var showSetTargetView = false

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
