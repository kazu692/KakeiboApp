//
//  ProgressRing.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/05/30.
//

import SwiftUI

struct ProgressRing: View {
    let progress: Double // 0.0 から 1.0 までの達成度合い
    let thickness: CGFloat // リングの太さ
    let accentColor: Color // 達成部分の色
    let backgroundColor: Color // 未達成部分の色

    var body: some View {
        ZStack {
            // 背景の円 (未達成部分)
            Circle()
                .stroke(backgroundColor, lineWidth: thickness)

            // 達成部分の円弧
            Circle()
                .trim(from: 0.0, to: progress) // progress に応じて描画範囲を調整
                .stroke(accentColor, lineWidth: thickness)
                .rotationEffect(.degrees(-90)) // 円の開始位置を上にする (デフォルトは右)
                .animation(.easeOut, value: progress) // progress の変化を滑らかにアニメーション
            Text("\(Int(progress * 100))%")
                .font(.title2)
                .bold()
                .foregroundColor(accentColor)
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            Text("達成度 25%")
            ProgressRing(progress: 0.25, thickness: 20, accentColor: .blue, backgroundColor: .gray.opacity(0.3))
                .frame(width: 150, height: 150)

            Text("達成度 75%")
            ProgressRing(progress: 0.75, thickness: 20, accentColor: .orange, backgroundColor: .gray.opacity(0.3))
                .frame(width: 150, height: 150)

            Text("達成度 100%以上")
            ProgressRing(progress: 1.0, thickness: 20, accentColor: .green, backgroundColor: .gray.opacity(0.3))
                .frame(width: 150, height: 150)

            Text("達成度 0%")
            ProgressRing(progress: 0.0, thickness: 20, accentColor: .red, backgroundColor: .gray.opacity(0.3))
                .frame(width: 150, height: 150)
        }
    }
}
