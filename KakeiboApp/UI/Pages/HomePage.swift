//
//  HomePage.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/05.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var viewModel = AccountBookViewModel()

    var body: some View {
        HomeTemplate(viewModel: viewModel)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
