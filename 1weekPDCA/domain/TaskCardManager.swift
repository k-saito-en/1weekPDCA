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
// リポジトリパターンの DB からデータコピー、変更されたデータを保持する役割
class TaskCardManager: ObservableObject{
    
    @Published var taskCardData = [
        (
            taskId: String,
            taskTitle: String,
            todoData: [(todoId: String, todoText: String, isDone: Bool)]
        )
    ]()
    
//    func appendTodo(index: Int) {
//        taskCardData[index].todoData.append((todoText: "", isDone: false))
//    }
//
//    func appendTask() {
//        taskCardData.append((taskTitle: "", [(todoText: "", isDone: false)]))
//    }
    
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
    
    // DB の状態を taskCardData に反映する関数
    func reloadTaskCardData() {
        
        let realmDataBaseManager = RealmDataBaseManager()
        
        // taskCardData を初期化
        taskCardData.removeAll()
        
        // DB を taskCardData に反映して View を更新
        taskCardData = realmDataBaseManager.getAllTaskCards()
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
    
//    @EnvironmentObject var taskCardManager: TaskCardManager
    
    let realm = try! Realm() // Realmインスタンスを生成
    
    // TaskCardDataのCRUDメソッド
    
    // 全てのTaskCardDataを取得する
    func getAllTaskCards() -> [(taskId: String, taskTitle: String, todoData: [(todoId: String, todoText: String, isDone: Bool)])] {
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
    
    // 新しいTaskCardDataを追加する
    func addTaskCard(taskCardManager: TaskCardManager) {
        let newTaskCardData = TaskCardData()
        try! realm.write {
            realm.add(newTaskCardData)
            
            // 状態を更新する
            taskCardManager.reloadTaskCardData()
        }
    }

    
    // 既存のTaskCardDataを更新する
    func updateTaskTitle(taskCardId: String, with newTaskTitle: String, taskCardManager: TaskCardManager) {
        
        // ID が一致する要素がなかった場合処理を中断する
        guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskCardId) else {
            return
        }
        
        try! realm.write {
            taskCardData.taskTitle = newTaskTitle
            
            // 状態を更新する
            taskCardManager.reloadTaskCardData()
        }
    }
    
    // 既存のTaskCardDataを削除する
    func deleteTaskCard(taskId: String, value: DragGesture.Value, taskCardManager: TaskCardManager) {
        if value.translation.width < -100 {
            guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskId) else {
                return
            }
            
            try! realm.write {
                realm.delete(taskCardData)
                
                // 状態を更新する
                taskCardManager.reloadTaskCardData()
            }
            print("Swiped left!")
        } else if value.translation.width > 100 {
            guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskId) else {
                return
            }
            
            try! realm.write {
                realm.delete(taskCardData)
                
                // 状態を更新する
                taskCardManager.reloadTaskCardData()
            }
            print("Swiped right!")
        }
    }

    
    // TodoDataのCRUDメソッド
    
    // 新しいTodoDataを追加する
    func addTodoData(taskId: String, taskCardManager: TaskCardManager) {
        guard let taskCardData = realm.object(ofType: TaskCardData.self, forPrimaryKey: taskId) else {
            return
        }
        
        let todoData = TodoData()
        
        try! realm.write {
            taskCardData.todoData.append(todoData)
            
            // 状態を更新する
            taskCardManager.reloadTaskCardData()
        }
    }

    // 既存のTodoDataを更新する
    func updateTodoText(todoId: String, with newTodoTitle: String, taskCardManager: TaskCardManager) {
        guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
            return
        }
        
        try! realm.write {
            todoData.todoTitle = newTodoTitle
            
            // 状態を更新する
            taskCardManager.reloadTaskCardData()
        }
    }
    
    // TodoDataのisDoneを更新する
    func toggleTodoDoneState(todoId: String, taskCardManager: TaskCardManager) {
        guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
            return
        }

        let isDone = !todoData.isDone // 現在と反対の値を入力し、true/falseを切り替える
        try! realm.write {
            todoData.isDone = isDone
            taskCardManager.reloadTaskCardData()
        }
    }

    
    // 既存のTodoDataを削除する
    func deleteTodoCard(todoId: String, value: DragGesture.Value, taskCardManager: TaskCardManager) {
        if value.translation.width < -100 {
            guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
                return
            }
            
            try! realm.write {
                realm.delete(todoData)
                
                // 状態を更新する
                taskCardManager.reloadTaskCardData()
            }
            print("Swiped left!")
        } else if value.translation.width > 100 {
            guard let todoData = realm.object(ofType: TodoData.self, forPrimaryKey: todoId) else {
                return
            }
            
            try! realm.write {
                realm.delete(todoData)
                
                // 状態を更新する
                taskCardManager.reloadTaskCardData()
            }
            print("Swiped right!")
        }
    }
    
    
}
