//
//  component.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/07.
//

import Foundation
import SwiftUI


struct BottomBar: View {
    
    // ボトムバーの状態管理
    @State private var selectedIndex = 0
    
    // ボトムバーのアイコン、ページ（view）
    let tabItems: [TabItem] = [
        TabItem(image: "graduationcap.fill", view: AnyView(Text("ActTabView()"))),
        TabItem(image: "square.fill", view: AnyView(Text("PlanDoTabView()"))),
        TabItem(image: "checkmark.circle.fill", view: AnyView(Text("CheckTabView()")))
    ]
    
    // ボトムバーの実装
    var body: some View {
        TabView(selection: $selectedIndex) {
            // tabItems.count だと定数じゃないから数値を指定しろって怒られた
            ForEach(0 ..< 3) { index in
                // その index の view を表示
                self.tabItems[index].view
                    .tabItem {
                        Image(systemName: self.tabItems[index].image)
                            .renderingMode(.template)
                            .foregroundColor(self.selectedIndex == index ? Color("UIColorGreen") : Color("UIColorGray"))
                    }
                    // 各 view にタグをつけて選択状態を管理
                    .tag(index)
            }
        }
    }
}
