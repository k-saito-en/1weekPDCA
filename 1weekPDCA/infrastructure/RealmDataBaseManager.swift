//
//  RealmDataBaseManager.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/03/08.
//

import Foundation
import SwiftUI

import RealmSwift

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

// MARK: DB の CRUD メソッド群
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

