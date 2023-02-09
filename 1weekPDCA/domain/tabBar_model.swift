//
//  tabBar_model.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/09.
//

import Foundation
import SwiftUI

// TabItems のモデル
struct TabItem {
    let image: String
    let view: AnyView
    // デフォルト引数 false を設定
    var isSelected: Bool = false
}
