//
//  SetTargetSavingsView.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/05/30. // 作成日を今日の日付に
//

import SwiftUI

struct SetTargetSavingsView: View {
    @Environment(\.dismiss) var dismiss // モーダルを閉じるための環境変数
    @ObservedObject var viewModel: AccountBookViewModel // AccountBookViewModel を受け取る

    // 目標貯金額の入力用State変数。ViewModelの既存の値で初期化
    @State private var targetAmountText: String

    @State private var showingAlert = false
    @State private var alertMessage = ""

    // Viewの初期化時に入力フィールドをViewModelの現在の目標貯金額で初期化する
    init(viewModel: AccountBookViewModel) {
        self.viewModel = viewModel
        _targetAmountText = State(initialValue: String(viewModel.targetSavings)) // 初期値を設定
    }

    var body: some View {
        NavigationView {
            VStack {
                Form { // Form を使用して入力フィールドを整理
                    Section(header: Text("目標貯金額を設定")) {
                        HStack {
                            Text("金額")
                            TextField("例: 50000", text: $targetAmountText)
                                .keyboardType(.numberPad) // 数値入力キーボード
                                .multilineTextAlignment(.trailing) // 右寄せ
                                .fixedSize(horizontal: false, vertical: true) // テキストが長くても折り返さない
                            Text("円")
                        }
                    }
                }
                .padding(.top) // フォーム上部に少しパディング
                
                Spacer() // フォームを上部に寄せる
                
                // 設定ボタン
                PrimaryButton(title: "目標を設定", action: {
                    if let amount = Double(targetAmountText), amount >= 0 {
                        viewModel.targetSavings = amount // ViewModelの目標貯金額を更新
                        dismiss() // 画面を閉じる
                    } else {
                        alertMessage = "有効な金額を入力してください。"
                        showingAlert = true
                    }
                })
                .padding()
            }
            .navigationTitle("目標貯金額") // ナビゲーションタイトル
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss() // 画面を閉じる
                    }
                }
            }
            .alert("入力エラー", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct SetTargetSavingsView_Previews: PreviewProvider {
    static var previews: some View {
        // ViewModel のインスタンスをプレビューに渡す
        SetTargetSavingsView(viewModel: AccountBookViewModel())
    }
}
