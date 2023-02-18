//
//  planDoData_model.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/18.
//

import Foundation
import SwiftUI

import SwiftUI

// PlanDoView での状態管理
class PlanDoData: ObservableObject {
    @Published var taskCards = [TaskCard]()
}

struct TaskCard {
    var taskTitle: String
    var taskProgress: Double
    var todos: [(text: String, isDone: Bool)]
}





