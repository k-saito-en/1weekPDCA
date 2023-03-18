//
//  TaskCardManager.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/21.
//

import Foundation
import SwiftUI
import RealmSwift

// PlanDo 画面の表示状況を管理
class TaskCardManager: ObservableObject{
    
    let realmDataBaseManager = RealmDataBaseManager()
    
    @Published var taskCardData = [
        (
            taskId: String,
            taskTitle: String,
            todoData: [(todoId: String, todoText: String, isDone: Bool)]
        )
    ]()
    
    // Create 処理
    func createTask(taskCardManager: TaskCardManager) {
        
        let newTaskCardData = TaskCardData()
        newTaskCardData.taskId = UUID().uuidString
        newTaskCardData.taskTitle = ""
        
        let newTodoData = TodoData()
        newTodoData.todoId = UUID().uuidString
        newTodoData.todoTitle = ""
        newTodoData.isDone = false
        
        newTaskCardData.todoData.append(newTodoData)
        
        taskCardData.append((newTaskCardData.taskId, newTaskCardData.taskTitle, [(newTodoData.todoId, newTodoData.todoTitle, newTodoData.isDone)]))
        
        realmDataBaseManager.realmCreateTaskCard(newTaskCardData: newTaskCardData, taskCardManager: taskCardManager)
    }

    
    func createTodo(taskIndex: Int, taskcardManager: TaskCardManager) {
        
        let newTodoData = TodoData()
        newTodoData.todoId = UUID().uuidString
        newTodoData.todoTitle = ""
        newTodoData.isDone = false
        
        taskCardData[taskIndex].todoData.append((newTodoData.todoId, newTodoData.todoTitle, newTodoData.isDone))
        
        realmDataBaseManager.realmCreateTodoData(
            taskId: taskCardData[taskIndex].taskId,
            newTodoData: newTodoData,
            taskCardManager: taskcardManager
        )
    }

    // Read 処理
    func reloadTaskCardData() {
        // DB を taskCardData に反映して View を更新
        taskCardData = realmDataBaseManager.realmReadAllTaskCards()
    }
    
    // Update 処理
    func updateTaskTitle(taskIndex: Int, newTaskTitle: String, taskCardManager: TaskCardManager) {
        realmDataBaseManager.realmUpdateTaskTitle(
            taskId: taskCardData[taskIndex].taskId,
            with: newTaskTitle,
            taskCardManager: taskCardManager
        )
    }
    
    func updateTodoText(taskIndex: Int, todoIndex: Int, newTodoText: String, taskCardManager: TaskCardManager) {
        realmDataBaseManager.realmUpdateTodoText(
            todoId: taskCardData[taskIndex].todoData[todoIndex].todoId,
            with: newTodoText,
            taskCardManager: taskCardManager
        )
    }
    
    func toggleTodoDoneState(taskIndex: Int, todoIndex: Int, taskCardManager: TaskCardManager) {
        taskCardData[taskIndex].todoData[todoIndex].isDone.toggle()
        
        realmDataBaseManager.realmToggleTodoDoneState(
            todoId: taskCardData[taskIndex].todoData[todoIndex].todoId,
            taskCardManager: taskCardManager
        )
    }
    
    // Delete 処理
    func deleteTask(taskIndex: Int, taskCardManager: TaskCardManager) {
        
        realmDataBaseManager.realmDeleteTaskCard(
            taskId: taskCardData[taskIndex].taskId,
            taskCardManager: taskCardManager)
        
        taskCardData.remove(at: taskIndex)
        
    }
    
    func deleteTodo(taskIndex: Int, todoIndex: Int, taskCardManager: TaskCardManager) {
        
            realmDataBaseManager.realmDeleteTodoCard(
                todoId: taskCardData[taskIndex].todoData[todoIndex].todoId,
                taskCardManager: taskCardManager
            )
            
            taskCardData[taskIndex].todoData.remove(at: todoIndex)
        
    }
}
