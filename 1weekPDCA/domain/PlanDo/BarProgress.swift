//
//  BarProgress.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

struct BarProgress {
    let progress: Double
    
    func getBarColor() -> Color {
        // ビジネスルールに基づいたバーの色を返す
        return ProgressColorUtils.getProgressColor(for: progress)
    }
}
