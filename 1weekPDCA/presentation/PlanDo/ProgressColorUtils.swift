//
//  ProgressColorUtils.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

// 色変更ロジックのまとめ
struct ProgressColorUtils {
    // プログレスバー・サークルの色変更関数
    static func getProgressColor(for progress: Double) -> Color {
        switch progress {
        case 0..<0.5:
            return Color.uiColorRed
        case 0.5...0.70:
            return Color.uiColorYellow
        default:
            return Color.uiColorGreen
        }
    }
}
