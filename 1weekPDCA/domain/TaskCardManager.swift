//
//  TaskCardManager.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/21.
//

import Foundation
import SwiftUI

// PlanDo 画面の表示状況を管理
// リポジトリパターンの DB からデータコピー、変更されたデータを保持する役割
class TaskCardManager: ObservableObject{
    
    @Published var taskCardData = [
        (
            taskTitle: String,
            todoData: [(todoText: String, isDone: Bool)]
        )
    ]()
    
    func appendTodo(index: Int) {
        taskCardData[index].todoData.append((todoText: "", isDone: false))
    }
    
    func appendTask() {
        taskCardData.append((taskTitle: "", [(todoText: "", isDone: false)]))
    }
    
    func deleteTodo(index: Int, todoIndex: Int, value: DragGesture.Value) {
        if value.translation.width < -100 {
            taskCardData[index].todoData.remove(at: todoIndex)
            print("Swiped left!")
        } else if value.translation.width > 100 {
            taskCardData[index].todoData.remove(at: todoIndex)
            print("Swiped right!")
        }
    }
    
    func deleteTask(index: Int, value: DragGesture.Value) {
        if value.translation.width < -100 {
            taskCardData.remove(at: index)
            print("Swiped left!")
        } else if value.translation.width > 100 {
            taskCardData.remove(at: index)
            print("Swiped right!")
        }
    }
    
    func toggleTodoDoneState(for index: Int, todoIndex: Int) {
        taskCardData[index].todoData[todoIndex].isDone.toggle()
    }


}
