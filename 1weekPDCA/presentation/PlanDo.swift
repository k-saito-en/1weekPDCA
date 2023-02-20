//
//  PlanDo.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/13.
//

import Foundation
import SwiftUI

// ドメイン層
class TaskCardManager: ObservableObject{
    
    @Published var taskCardData = [
        (
            taskTitle: String,
            todoData: [(todoText: String, isDone: Bool)]
        )
    ]()
}

// アプリケーション層
func calculateWeekProgress(_ taskCardData: [(taskTitle: String, todoData: [(todoText: String, isDone: Bool)])]) -> Double {
    let completedTasks = taskCardData.reduce(0) { count, card in
        count + card.todoData.filter { $0.isDone }.count}
    return Double(completedTasks) / Double(taskCardData.reduce(0) { $0 + $1.todoData.count })
}


//　プレゼンテーション層

struct WeekProgressBarCardView: View {
    @EnvironmentObject var taskCardManager: TaskCardManager
    
    let today = Date()
    let calendar = Calendar.current
    
    var body: some View {
        let weekProgress = calculateWeekProgress(taskCardManager.taskCardData)
        let weekRange = getWeekRange()
        
        CardView {
            HStack {
                Text(formatWeekRangeText(weekRange))
                    .textStyle(for: .title, color: Color.uiColorGray)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                CustomProgressBar(progress: weekProgress)
                    .frame(height: 20)
                
                Spacer()
            }
        }
        .frame(height: 120)
    }
}

// アプリケーション層



// プレゼンテーション層
struct TaskCardView: View {
    @EnvironmentObject var taskCardManager: TaskCardManager
    
    var taskIndex: Int
    
    init(index: Int) {
            self.taskIndex = index
        }
    
    @State private var cardHeight: CGFloat = 120 // 初期値を設定
    

    var circleProgress: Double {
        let doneCount = Double(taskCardManager.taskCardData[taskIndex].todoData.filter { $0.isDone }.count)
        let totalCount = Double(taskCardManager.taskCardData[taskIndex].todoData.count)
        let progress = doneCount / totalCount
        return progress
    }

    var body: some View {
        CardView {
            VStack {
                HStack {
                    // 30文字までに制限？
                    TextField("task title", text: $taskCardManager.taskCardData[taskIndex].taskTitle, axis: .vertical)
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
                ForEach(taskCardManager.taskCardData[taskIndex].todoData.indices, id: \.self) { todoIndex in
                    let todoBinding = Binding<String>(
                        get: {
                            taskCardManager.taskCardData[taskIndex].todoData[todoIndex].todoText
                        },
                        set: { newTodoText in
                            taskCardManager.taskCardData[taskIndex].todoData[todoIndex].todoText = newTodoText
                        }
                    )
                    // todo カードの実装
                    HStack {
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(maxWidth: UIScreen.main.bounds.width / 10 * 7, maxHeight: .infinity)
                                .foregroundColor(taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone ? Color.uiColorGreen.opacity(0.3) : Color.uiColorGray.opacity(0.2))
                            
                            HStack {
                                // ラジオボタンの実装
                                Image(systemName: taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone ? Color.uiColorGreen.opacity(0.3) : Color.uiColorGray.opacity(0.2))
                                    .onTapGesture {
                                        taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone.toggle()
                                        // 動作確認用
                                        print(taskCardManager.taskCardData.reduce(0) { count, card in
                                            count + card.todoData.filter { $0.isDone }.count})

                                        }

                                
                                VStack {
                                    Color.clear.frame(width:10, height: 4)
                                    
                                    TextField("ToDo", text: todoBinding, axis: .vertical)
                                        .textStyle(for: .body, color: .uiColorWhite)
                                        .frame(width: UIScreen.main.bounds.width / 10 * 6)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Color.clear.frame(width:10, height: 4)
                                }
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    taskCardManager.taskCardData[taskIndex].todoData.remove(atOffsets: offsets)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // 新しいToDoカードを追加する
                        taskCardManager.taskCardData[taskIndex].todoData.append((todoText: "", isDone: false))
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
    
    @StateObject var taskCardManager = TaskCardManager()
    @State private var newTaskCardIsTaskDone = false
    
    var body: some View {
        ZStack {
            Color.backGroundColorGray.ignoresSafeArea()
            ScrollView {
                WeekProgressBarCardView().environmentObject(taskCardManager)
                ForEach(self.taskCardManager.taskCardData.indices, id: \.self) { index in
                    TaskCardView(index: index)
                }
                
                Color.clear.frame(width:15, height: 50)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.taskCardManager.taskCardData.append((taskTitle: "", [(todoText: "", isDone: false)]))
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
        .environmentObject(taskCardManager)
    }
}



//MARK: プレビューの設定
//struct PlanDoPage_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanDoView()
//    }
//}

