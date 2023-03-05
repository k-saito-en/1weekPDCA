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
    
    @Persisted(primaryKey: true) var taskId = UUID().uuidString // id
    
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
    
    // TaskCardDataのCRUDメソッド
    
    // 全てのTaskCardDataを取得する
    func getAllTaskCards() -> Results<TaskCardData> {
        return realm.objects(TaskCardData.self)
    }
    
    // 新しいTaskCardDataを追加する
    func addTaskCard(taskCardData: TaskCardData) {
        try! realm.write {
            realm.add(taskCardData)
        }
    }
    
    // 既存のTaskCardDataを更新する
    func updateTaskCard(taskCardData: TaskCardData, with newTaskTitle: String) {
        try! realm.write {
            taskCardData.taskTitle = newTaskTitle
        }
    }
    
    // 既存のTaskCardDataを削除する
    func deleteTaskCard(taskCardData: TaskCardData) {
        try! realm.write {
            realm.delete(taskCardData)
        }
    }
    
    // TodoDataのCRUDメソッド
    
    // 新しいTodoDataを追加する
    func addTodoData(todoData: TodoData, to taskCardData: TaskCardData) {
        try! realm.write {
            taskCardData.todoData.append(todoData)
        }
    }
    
    // 既存のTodoDataを更新する
    func updateTodoData(todoData: TodoData, with newTodoTitle: String) {
        try! realm.write {
            todoData.todoTitle = newTodoTitle
        }
    }
    
    // TodoDataのisDoneを更新する
    func updateTodoDoneState(todoData: TodoData, isDone: Bool) {
        try! realm.write {
            todoData.isDone = isDone
        }
    }
    
    // 既存のTodoDataを削除する
    func deleteTodoData(todoData: TodoData) {
        try! realm.write {
            realm.delete(todoData)
        }
    }
}
