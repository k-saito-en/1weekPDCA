//
//  component.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/07.
//

import Foundation
import SwiftUI

// ボトムバーの実装
struct BottomBar: View {
    var body: some View {
        TabView {
         // Act画面
         Text("ActTabView()")
            .tabItem {
                Image(systemName: "graduationcap.fill")
                    .renderingMode(.template)
                    .foregroundColor(Color("UIColorGray"))
            }
         // Plan・Do画面
         Text("PlanDoTabView()")
            .tabItem {
                Image(systemName: "square.fill")
                    .renderingMode(.template)
                    .foregroundColor(Color("UIColorGray"))
            }
         // Check画面
         Text("CheckTabView()")
            .tabItem {
                Image(systemName: "checkmark.circle.fill")
                    .renderingMode(.template)
                    .foregroundColor(Color("UIColorGray"))
            }
        }
    }
}
