//
//  CustomProgressBar.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

// アプリケーション層
func getProgressColor(progress: Double) -> Color {
    if progress < 0.3 {
        return .uiColorRed
    } else if progress < 0.7 {
        return .uiColorYellow
    } else {
        return .uiColorGreen
    }
}
    
// プレゼンテーション層
struct CustomProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Rectangle().frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: 10)
                    .foregroundColor(getProgressColor(progress: progress))
            }.cornerRadius(45.0)
        }
    }
}







