//
//  ProgressBarUseCase.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

protocol ProgressBarUseCase {
    func calculateProgress(for task: Task) -> BarProgress
}

class ProgressBarUseCaseImpl: ProgressBarUseCase {
    func calculateProgress(for task: Task) -> BarProgress {
        // ビジネスルールに基づいた進捗状況を計算する
        let progressValue = task.currentProgress / task.totalProgress
        return BarProgress(progress: progressValue)
    }
}
