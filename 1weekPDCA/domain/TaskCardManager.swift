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
    func deleteTask(taskIndex: Int, value: DragGesture.Value, taskCardManager: TaskCardManager) {
        if value.translation.width < -100 {
            
            realmDataBaseManager.realmDeleteTaskCard(
                taskId: taskCardData[taskIndex].taskId,
                taskCardManager: taskCardManager)
            
            taskCardData.remove(at: taskIndex)
            
            print("Swiped left!")
            
        } else if value.translation.width > 100 {
            
            realmDataBaseManager.realmDeleteTaskCard(
                taskId: taskCardData[taskIndex].taskId,
                taskCardManager: taskCardManager)
            
            taskCardData.remove(at: taskIndex)
            
            print("Swiped right!")
        }
    }
    
    func deleteTodo(taskIndex: Int, todoIndex: Int, value: DragGesture.Value, taskCardManager: TaskCardManager) {
        
        if value.translation.width < -100 {
            
            realmDataBaseManager.realmDeleteTodoCard(
                todoId: taskCardData[taskIndex].todoData[todoIndex].todoId,
                taskCardManager: taskCardManager
            )
            
            taskCardData[taskIndex].todoData.remove(at: todoIndex)
            
            print("Swiped left!")
        } else if value.translation.width > 100 {
            
            realmDataBaseManager.realmDeleteTodoCard(
                todoId: taskCardData[taskIndex].todoData[todoIndex].todoId,
                taskCardManager: taskCardManager
            )
            
            taskCardData[taskIndex].todoData.remove(at: todoIndex)
            
            print("Swiped right!")
        }
    }
}

// MARK: エンティティ定義
final class TaskCardData: Object, Identifiable {
    
    @Persisted(primaryKey: true) var taskId = UUID().uuidString // id
    
    @Persisted var taskTitle: String = ""
    @Persisted var todoData: RealmSwift.List<TodoData> // リレーション設定
    
    // プロパティを設定
    convenience init(taskTitle: String, todoData: [TodoData] = []) {
            self.init()
            self.taskTitle = taskTitle
            self.todoData = .init()
            self.todoData.append(objectsIn: todoData)
        }
}

final class TodoData: Object, Identifiable {
    
    @Persisted(primaryKey: true) var todoId = UUID().uuidString // id
    
    @Persisted var todoTitle: String = ""
    @Persisted var isDone: Bool = false
    
    @Persisted(originProperty: "todoData") var TaskCardData: LinkingObjects<TaskCardData> //リレーション設定
    
    // プロパティを設定
    convenience init(todoTitle: String, isDone: Bool = false) {
        
            self.init()
            self.todoTitle = todoTitle
            self.isDone = isDone
        }
}

final class RealmDataBaseManager {
    
    let realm = try! Realm() // Realmインスタンスを生成
    
    // Create 処理
    func realmCreateTaskCard(newTaskCardData: TaskCardData, taskCardManager: TaskCardManager) {
        try! realm.write {
            realm.add(newTaskCardData)
        }
    }
    
    func realmCreateTodoData(taskId: String, newTodoData: TodoData, taskCardManager: TaskCardManager) {
        guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskId) else {
            return
        }
        
        try! realm.write {
            taskCardData.todoData.append(newTodoData)
        }
    }
    
    // Read 処理
    func realmReadAllTaskCards() -> [(taskId: String, taskTitle: String, todoData: [(todoId: String, todoText: String, isDone: Bool)])] {
        // 配列の要素をタプル型で定義する
        var result: [(taskId: String, taskTitle: String, todoData: [(todoId: String, todoText: String, isDone: Bool)])] = []
        
        // 全てのTaskCardDataを取得する
        let taskCards = realm.objects(TaskCardData.self)
        
        // 各TaskCardDataごとに処理を行う
        for taskCard in taskCards {
            let taskId = taskCard.taskId
            let taskTitle = taskCard.taskTitle
            var todos: [(todoId: String, todoText: String, isDone: Bool)] = []
            
            // 各TaskCardDataのtodoDataを変換し、配列に追加する
            for todo in taskCard.todoData {
                todos.append((todoId: todo.todoId, todoText: todo.todoTitle, isDone: todo.isDone))
            }
            
            result.append((taskId: taskId, taskTitle: taskTitle, todoData: todos))
        }
        
        return result
    }
    
    // Update 処理
    func realmUpdateTaskTitle(taskId: String, with newTaskTitle: String, taskCardManager: TaskCardManager) {
        
        // ID が一致する要素がなかった場合処理を中断する
        guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskId) else {
            return
        }
        
        try! realm.write {
            taskCardData.taskTitle = newTaskTitle
            print("update\(newTaskTitle)")
        }
    }
    
    func realmUpdateTodoText(todoId: String, with newTodoTitle: String, taskCardManager: TaskCardManager) {
        guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
            return
        }
        
        try! realm.write {
            todoData.todoTitle = newTodoTitle
            print("update\(newTodoTitle)")
        }
    }
    
    // TodoDataのisDoneを更新する
    func realmToggleTodoDoneState(todoId: String, taskCardManager: TaskCardManager) {
        guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
            return
        }

        let isDone = !todoData.isDone // 現在と反対の値を入力し、true/falseを切り替える
        try! realm.write {
            todoData.isDone = isDone
        }
    }
    
    // Delete 処理
    func realmDeleteTaskCard(taskId: String, taskCardManager: TaskCardManager) {
        
        guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskId) else {
            return
        }
        
        try! realm.write {
            realm.delete(taskCardData)
        }
        print("Delete TaskCard")
    }

    func realmDeleteTodoCard(todoId: String, taskCardManager: TaskCardManager) {
        guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
            return
        }
        
        try! realm.write {
            realm.delete(todoData)
        }
        print("Delete TodoCard")
        
    }
}
