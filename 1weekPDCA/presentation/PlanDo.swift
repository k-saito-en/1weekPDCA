//
//  PlanDo.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/13.
//

import Foundation
import SwiftUI


class TaskCardsManager: ObservableObject,TaskCardsManagerProtocol {
    
    @Published var taskCardsData = [
        (
            taskCard: TaskCardView,
            doneCount: Double,
            todoCount: Double
        )
    ]()
    
    func getTotalDoneCount() -> Double {
        return taskCardsData.map { $0.doneCount }.reduce(0, +)
    }
    
    func getTotalTodoCount() -> Double {
        return taskCardsData.map { $0.todoCount }.reduce(0, +)
    }
    
    func getProgress() -> Double {
        let totalDoneCount = getTotalDoneCount()
        let totalTodoCount = getTotalTodoCount()
        if totalTodoCount == 0 {
            return 0.0
        }
        return totalDoneCount / totalTodoCount
    }
    
    func updateTaskCardData(cardIndex: Int, doneCount: Double, totalCount: Double) {
        taskCardsData[cardIndex].doneCount = doneCount
        taskCardsData[cardIndex].todoCount = totalCount
    }
    
    func getIndex(for id: UUID) -> Int? {
        return taskCardsData.firstIndex(where: { $0.taskCard.id == id })
    }
}

// アプリケーション層
protocol TaskCardsManagerProtocol {
    func getTotalDoneCount() -> Double
    func getTotalTodoCount() -> Double
    func getProgress() -> Double
}

//　プレゼンテーション層

struct WeekProgressBarCardView: View {
    @EnvironmentObject var taskCardsManager: TaskCardsManager
    
    let today = Date()
    let calendar = Calendar.current
    
    var body: some View {
        let totalDoneCount = taskCardsManager.getTotalDoneCount()
        let totalTodoCount = taskCardsManager.getTotalTodoCount()
        let progress = taskCardsManager.getProgress()
        
        let weekRange = getWeekRange()
        
        CardView {
            HStack {
                Text(formatWeekRangeText(weekRange))
                    .textStyle(for: .title, color: Color.uiColorGray)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                let progressBarUseCase = ProgressBarUseCase()
                CustomProgressBar(task: Task(taskName: "Calculate WeekProgressBar", currentProgress: totalDoneCount, totalProgress: totalTodoCount), progressBarUseCase: progressBarUseCase)
                    .frame(height: 20)
                
                Spacer()
            }
        }
        .frame(height: 120)
    }
}

// アプリケーション層
func == (lhs: TaskCardView, rhs: TaskCardView) -> Bool {
    // `id`が一致する場合にはtrueを返す
    return lhs.id == rhs.id
}

func updateTaskCardData(todos: [(text: String, isDone: Bool)], index: Int, taskCardsManager: TaskCardsManager) {
    let doneCount = Double(todos.filter { $0.isDone }.count)
    let totalCount = Double(todos.count)
    taskCardsManager.updateTaskCardData(cardIndex: index, doneCount: doneCount, totalCount: totalCount)
}

func calculateCircleProgress(todos: [(text: String, isDone: Bool)]) -> Double {
    guard !todos.isEmpty else {
        return 0.0
    }
    let doneCount = Double(todos.filter { $0.isDone }.count)
    let totalCount = Double(todos.count)
    let progress = doneCount / totalCount
    return progress
}

struct TaskCardView: View, Equatable {
    
    
    @EnvironmentObject var taskCardsManager: TaskCardsManager
    
    @State private var taskTitle = ""
    @State private var cardHeight: CGFloat = 120 // 初期値を設定
    // ToDoカードの配列　タプルで管理している
    @State private var todos: [(text: String, isDone: Bool)] = [] {
        didSet {
            updateTaskCardData(todos: todos, index: index, taskCardsManager: taskCardsManager)
        }
    }
    let id: UUID
    var index: Int {
        taskCardsManager.getIndex(for: id)!
    }
    
    var circleProgress: Double {
        calculateCircleProgress(todos: todos)
    }
    
    func taskCardView(for index: Int) -> some View {
        let taskBinding = Binding<String>(
            get: {
                todos[index].text
            },
            set: { newText in
                todos[index].text = newText
            }
        )
        return HStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxWidth: UIScreen.main.bounds.width / 10 * 7, maxHeight: .infinity)
                    .foregroundColor(todos[index].isDone ? Color.uiColorGreen.opacity(0.3) : Color.uiColorGray.opacity(0.2))
                
                HStack {
                    // ラジオボタンの実装
                    Image(systemName: todos[index].isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(todos[index].isDone ? Color.uiColorGreen.opacity(0.3) : Color.uiColorGray.opacity(0.2))
                        .onTapGesture {
                            todos[index].isDone.toggle()
                            print(taskCardsManager.taskCardsData.reduce(0.0) { $0 + $1.doneCount })
                            
                        }
                    
                    
                    VStack {
                        Color.clear.frame(width:10, height: 4)
                        
                        TextField("ToDo", text: taskBinding, axis: .vertical)
                            .textStyle(for: .body, color: .uiColorWhite)
                            .frame(width: UIScreen.main.bounds.width / 10 * 6)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Color.clear.frame(width:10, height: 4)
                    }
                }
            }
        }
    }

    var body: some View {
        CardView {
            VStack {
                HStack {
                    // 30文字までに制限？
                    TextField("task title", text: $taskTitle, axis: .vertical)
                        .textStyle(for: .title, color: .uiColorGray)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                    
                    customProgressCircle(circleProgress: circleProgress)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 20)
                
                }
                // 空のViewを追加し、高さを10の隙間を開ける
                Color.clear.frame(height: 10)
                
                // 追加されたHStackを表示する
                ForEach(todos.indices, id: \.self) { index in
                    taskCardView(for: index)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // 新しいToDoカードを追加する
                        todos.append((text: "", isDone: false))
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.main.bounds.width / 10 * 7, height: 40)
                            .foregroundColor(Color.uiColorGray).opacity(0.2)
                            .overlay(Image(systemName: "plus")
                                .foregroundColor(Color.uiColorGray))
                    }
                }
            }
        }
    }
}

    
//MARK: PlanDo 画面全体の実装
struct PlanDoView: View {
    
    @StateObject var taskCardsManager = TaskCardsManager()
    @State private var newTaskCardIsTaskDone = false
    
    var body: some View {
        ZStack {
            Color.backGroundColorGray.ignoresSafeArea()
            ScrollView {
                WeekProgressBarCardView().environmentObject(taskCardsManager)
                ForEach(taskCardsManager.taskCardsData.indices, id: \.self) { index in
                    self.taskCardsManager.taskCardsData[index].taskCard
                        .environmentObject(self.taskCardsManager)
                }
                
                Color.clear.frame(width:15, height: 50)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.taskCardsManager.taskCardsData.append((taskCard: TaskCardView(id: UUID()), doneCount: 0.0, todoCount: 0.0))
                    }) {
                        ZStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 80 ,height: 80)
                                .foregroundColor(Color.uiColorYellow).opacity(0.5)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 75 ,height: 75)
                                .foregroundColor(Color.uiColorYellow)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Color.clear.frame(width:15, height: 4)
                }
                
                Color.clear.frame(width:15, height: 5)
            }
        }
        .environmentObject(taskCardsManager)
    }
}



//MARK: プレビューの設定
//struct PlanDoPage_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanDoView()
//    }
//}

