//
//  HomeTemplate.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/05/27.
//

import SwiftUI

struct HomeTemplate: View {
    @ObservedObject var viewModel: AccountBookViewModel

    @State private var showAddExpenseView = false
    @State private var showAddIncomeView = false
    @State private var showSetTargetView = false
    @State private var selectedTransactionFilter: TransactionFilter = .all
    @State private var isDateFilterPresented = false
    @State private var filterStartDate: Date = {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
    }()

    @State private var filterEndDate: Date = {
        let calendar = Calendar.current
        let now = Date()
        if let range = calendar.range(of: .day, in: .month, for: now),
           let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) {
            return calendar.date(byAdding: .day, value: range.count - 1, to: firstDay) ?? now
        }
        return now
    }()


    var body: some View {
        NavigationView {
            VStack(spacing: 8) { // 上部の余白を詰める
                // 円グラフと残高表示
                HStack(alignment: .center, spacing: 16) {
                    ProgressRing(
                        progress: viewModel.savingsProgressPercentage,
                        thickness: 15,
                        accentColor: .green,
                        backgroundColor: .gray.opacity(0.3)
                    )
                    .frame(width: 120, height: 120)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        AppText(text: "現在の残高", font: .title2)
                        AppText(text: "\(Int(viewModel.balance)) 円", font: .largeTitle, color: .blue)
                        AppText(text: "目標: \(Int(viewModel.targetSavings)) 円", font: .title3, color: .gray)
                        
                        HStack {
                            PrimaryButton(title: "目標を設定") {
                                showSetTargetView.toggle()
                            }
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    .scaleEffect(0.75)
                }
                .padding(.leading, 26)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // 表示フィルタ
                Picker("表示項目", selection: $selectedTransactionFilter) {
                    Text("すべて").tag(TransactionFilter.all)
                    Text("収入のみ").tag(TransactionFilter.income)
                    Text("支出のみ").tag(TransactionFilter.expense)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // 収支リスト（スペース拡大）
                List {
                    Section(header:
                        HStack {
                            AppText(text: headerText, font: .headline)
                            Spacer()
                            AppText(text: periodTotalAmountText, font: .headline, color: periodTotalColor)
                            Button(action: {
                                isDateFilterPresented = true
                            }) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                            }
                        }
                    ) {
                        ForEach(filteredTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let transaction = viewModel.allTransactions[index]
                                viewModel.deleteTransaction(transaction)
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .frame(maxHeight: .infinity) // リストを最大限表示
                .padding(.top, 4)

                // ボタン群
                HStack(spacing: 12) {
                    PrimaryButton(title: "支出を追加") {
                        showAddExpenseView.toggle()
                    }
                    PrimaryButton(title: "収入を追加") {
                        showAddIncomeView.toggle()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("家計簿")
        }
        .sheet(isPresented: $showAddExpenseView) {
            AddTransactionModal(viewModel: viewModel, transactionType: .expense)
        }
        .sheet(isPresented: $showAddIncomeView) {
            AddTransactionModal(viewModel: viewModel, transactionType: .income)
        }
        .sheet(isPresented: $showSetTargetView) {
            SetTargetSavingsView(viewModel: viewModel)
        }
        .sheet(isPresented: $isDateFilterPresented) {
            NavigationView {
                VStack(spacing: 16) {
                    DatePicker("開始日", selection: $filterStartDate, displayedComponents: [.date])
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    DatePicker("終了日", selection: $filterEndDate, in: filterStartDate..., displayedComponents: [.date])
                        .environment(\.locale, Locale(identifier: "ja_JP"))

                    PrimaryButton(title: "完了") {
                        isDateFilterPresented = false
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
                .navigationTitle("表示期間を選択")
            }
        }
    }

    // 絞り込み後のトランザクション
    private var filteredTransactions: [TransactionItem] {
        let rangeFiltered = viewModel.allTransactions.filter {
            $0.date >= filterStartDate && $0.date <= filterEndDate
        }
        switch selectedTransactionFilter {
        case .all:
            return rangeFiltered
        case .income:
            return rangeFiltered.filter { $0.type == .income }
        case .expense:
            return rangeFiltered.filter { $0.type == .expense }
        }
    }
    
    private var headerText: String {
        switch selectedTransactionFilter {
        case .all:
            return "最近の収支"
        case .income:
            return "最近の収入"
        case .expense:
            return "最近の支出"
        }
    }
    // 合計金額の計算（収支合計）
    private var periodTotalAmount: Double {
        filteredTransactions.reduce(0) { result, item in
            switch item.type {
            case .income:
                return result + item.amount
            case .expense:
                return result - item.amount
            }
        }
    }
    
    private var periodTotalAmountText: String {
        let amount = Int(periodTotalAmount)
        return (amount >= 0 ? "+\(amount)" : "\(amount)") + " 円"
    }

    private var periodTotalColor: Color {
        periodTotalAmount >= 0 ? .green : .red
    }

    private enum TransactionFilter {
        case all, income, expense
    }
}

struct HomeTemplate_Previews: PreviewProvider {
    static var previews: some View {
        HomeTemplate(viewModel: AccountBookViewModel())
    }
}
