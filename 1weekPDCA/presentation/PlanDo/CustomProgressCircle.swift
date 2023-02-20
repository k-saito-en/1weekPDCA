//
//  CustomProgressCircle.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

// プログレスサークルの実装
struct customProgressCircle: View {
    var circleProgress: Double
    
    var body: some View {
        ZStack {
            // 背景の円
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(Color.uiColorGray)

            // 進捗を示す円
            Circle()
                .trim(from: 0.0, to: min(circleProgress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(getProgressColor(progress: circleProgress))
                .rotationEffect(Angle(degrees: 270.0))
            
            // 一回り小さな円
            Circle()
                .fill(getProgressColor(progress: circleProgress).opacity(0.5))
                .frame(width: 35, height: 35)
        }
    }
}
