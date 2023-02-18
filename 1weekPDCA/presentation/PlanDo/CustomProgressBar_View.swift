//
//  CustomProgressBar.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

struct CustomProgressBar: View {
    var task: Task
    var progressBarUseCase: ProgressBarUseCase
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.uiColorGray)
                
                Rectangle().frame(width: min(CGFloat(progressBarUseCase.calculateProgress(for: task).progress) * geometry.size.width, geometry.size.width), height: 10)
                    .foregroundColor(progressBarUseCase.calculateProgress(for: task).getBarColor())
            }.cornerRadius(45.0)
        }
    }
}





