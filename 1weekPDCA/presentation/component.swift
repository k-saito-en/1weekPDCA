//
//  component.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/07.
//

import Foundation
import SwiftUI


// TabアイコンとViewを設定
// 現時点ではText()でモック化
let tabItems: [TabItem] = [
    TabItem(image: "graduationcap.fill", view: AnyView(Text("ActTabView()"))),
    TabItem(image: "square.fill", view: AnyView(Text("PlanDoTabView()"))),
    TabItem(image: "checkmark.circle.fill", view: AnyView(Text("CheckTabView()")))
]

// ボトムバーの実装
struct BottomBar: View {
    
    var body: some View {
        TabView {
            // `image`をid（識別子）として反復処理を実装
            ForEach(tabItems, id: \.image) { item in
                item.view
                    .tabItem {
                        Image(systemName: item.image)
                            .renderingMode(.template)
                            .foregroundColor(Color("UIColorGray"))
                    }
            }
        }
    }
}
