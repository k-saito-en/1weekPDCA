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
    static let titleTextSize: CGFloat = 20
    static let bodyTextSize: CGFloat = 12
    static let progressCircleTextSize: CGFloat = 40
}


// テキストスタイル
enum TextStyle {
    case title
    case body
    case progressCircle
}

func font(for style: TextStyle) -> Font {
    switch style {
    case .title:
        return Font.system(size: TextSize.titleTextSize, weight: .bold, design: .default)
    case .body:
        return Font.system(size: TextSize.bodyTextSize, weight: .regular, design: .default)
    case .progressCircle:
        return Font.system(size: TextSize.progressCircleTextSize, weight: .bold, design: .default)
    }
}

extension Text {
    func textStyle(for style: TextStyle, color: Color) -> Text {
        // _weekPDCA は自分で定義した WeekPDCA クラスのインスタンス
        self.font(_weekPDCA.font(for: style))
            .foregroundColor(color)
    }
}


extension TextField {
    func textStyle(for style: TextStyle, color: Color) -> some View {
        // _weekPDCA は自分で定義した WeekPDCA クラスのインスタンス
        self.font(_weekPDCA.font(for: style)) 
            .foregroundColor(color)
    }
}




