//
//  theme.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/07.
//

import Foundation
import SwiftUI

// テキストサイズ
struct TextSize {
    static let titleTextSize: CGFloat = 18
    static let bodyTextSize: CGFloat = 12
    static let progressCircleTextSize: CGFloat = 40
}


// テキストスタイル
struct TextStyles {
    
    // タイトルテキストの指定（Colorは引数で都度指定）
    static func titleText(color: Color) -> Text {
        return Text(verbatim: "")
            .font(Font.system(size: TextSize.titleTextSize, weight: .medium, design: .default))
            .foregroundColor(color)
    }
    
    // 本文テキストの指定（Colorは引数で都度指定）
    static func bodyText(color: Color) -> Text {
        return Text(verbatim: "")
            .font(Font.system(size: TextSize.bodyTextSize, weight: .regular, design: .default))
            .foregroundColor(color)
    }
    
    // プログレスサークルテキストの指定（Colorは引数で都度指定）
    // 達成率によって色を変化させる予定なのでこの色変更可能な実装の方が都合がよさそう
    static func progressCircleText(color: Color) -> Text {
        return Text(verbatim: "")
            .font(Font.system(size: TextSize.progressCircleTextSize, weight: .bold, design: .default))
            .foregroundColor(color)
    }
}
