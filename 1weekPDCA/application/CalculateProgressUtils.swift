//
//  calculateProgressUtils.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/21.
//

import Foundation
import SwiftUI

struct CalculateProgressUtils {
    
    // プログレスバーの進捗計算
    func calculateWeekProgress(taskCardData: [(taskId: String, taskTitle: String, todoData: [(todoId: String, todoText: String, isDone: Bool)])]) -> Double {
        let completedTasks = taskCardData.reduce(0) { count, card in
            count + card.todoData.filter { $0.isDone }.count
        }
        let totalCount = taskCardData.reduce(0) { $0 + $1.todoData.count }
        return totalCount > 0 ? Double(completedTasks) / Double(totalCount) : 0.0
    }
    
    // プログレスサークルの進捗計算
    func caluculateCircleProgress(index: Int, taskCardManager: TaskCardManager) -> Double {
        let doneCount = Double(taskCardManager.taskCardData[index].todoData.filter { $0.isDone }.count)
        let totalCount = Double(max(1, taskCardManager.taskCardData[index].todoData.count))
        let progress = doneCount / totalCount
        return progress
    }
}
