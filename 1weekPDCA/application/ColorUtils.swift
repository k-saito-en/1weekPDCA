//
//  ProgressColorUtils.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

// 色変更ロジックのまとめ
struct ColorUtils {
    // プログレスバー・サークルの色変更関数
    func getProgressColor(for progress: Double) -> Color {
        switch progress {
        case 0..<0.5:
            return Color.uiColorRed
        case 0.5...0.69:
            return Color.uiColorYellow
        default:
            return Color.uiColorGreen
        }
    }
    
    func getIsDoneColor(for isDone: Bool) -> Color {
        return isDone ? Color.uiColorGreen.opacity(0.3) : Color.uiColorGray.opacity(0.2)
    }
}
