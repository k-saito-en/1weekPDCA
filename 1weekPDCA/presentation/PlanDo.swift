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
func getIsDoneColor(for isDone: Bool) -> Color {
    return isDone ? Color.uiColorGreen.opacity(0.3) : Color.uiColorGray.opacity(0.2)
}

func toggleTodoDoneState(for index: Int, todoIndex: Int, in taskCardManager: TaskCardManager) {
    taskCardManager.taskCardData[index].todoData[todoIndex].isDone.toggle()
}

func caluculateCircleProgress(index: Int, taskCardManager: TaskCardManager) -> Double {
    let doneCount = Double(taskCardManager.taskCardData[index].todoData.filter { $0.isDone }.count)
    let totalCount = Double(taskCardManager.taskCardData[index].todoData.count)
    let progress = doneCount / totalCount
    return progress
}




// プレゼンテーション層
struct TaskCardListView: View {
    
    @EnvironmentObject var taskCardManager: TaskCardManager
    
    var body: some View {
        ForEach(taskCardManager.taskCardData.indices, id: \.self) { index in
            CardView {
                VStack {
                    HStack {
                        // 30文字までに制限？
                        TextField("task title", text: $taskCardManager.taskCardData[index].taskTitle, axis: .vertical)
                            .textStyle(for: .title, color: .uiColorGray)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                        
                        customProgressCircle(circleProgress: caluculateCircleProgress(index: index, taskCardManager: taskCardManager))
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 20)
                    
                    }
                    // 空のViewを追加し、高さを10の隙間を開ける
                    Color.clear.frame(height: 10)
                    
                    // 追加された todo カードを表示する
                    ForEach(taskCardManager.taskCardData[index].todoData.indices, id: \.self) { todoIndex in
                        // todo カードの実装
                        HStack {
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(maxWidth: UIScreen.main.bounds.width / 10 * 7, maxHeight: .infinity)
                                    .foregroundColor(getIsDoneColor(for: taskCardManager.taskCardData[index].todoData[todoIndex].isDone))
                                
                                HStack {
                                    // ラジオボタンの実装
                                    Image(systemName: taskCardManager.taskCardData[index].todoData[todoIndex].isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(getIsDoneColor(for: taskCardManager.taskCardData[index].todoData[todoIndex].isDone))
                                        .onTapGesture {
                                                toggleTodoDoneState(for: index, todoIndex: todoIndex, in: taskCardManager)
                                                // 動作確認用
                                                print(taskCardManager.taskCardData.reduce(0) { count, card in
                                                    count + card.todoData.filter { $0.isDone }.count})
                                            }

                                    
                                    VStack {
                                        Color.clear.frame(width:10, height: 4)
                                        
                                        TextField("ToDo", text: $taskCardManager.taskCardData[index].todoData[todoIndex].todoText, axis: .vertical)
                                            .textStyle(for: .body, color: .uiColorWhite)
                                            .frame(width: UIScreen.main.bounds.width / 10 * 6)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Color.clear.frame(width:10, height: 4)
                                    }
                                }
                            }
                        }
                        
                        // スワイプで todo を削除
                        .gesture(DragGesture()
                            .onEnded { value in
                                taskCardManager.deleteTodo(index: index, todoIndex: todoIndex, value: value)
                            })
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            // 新しいToDoカードを追加する
                            taskCardManager.appendTodo(index: index)
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
            // スワイプで task を削除
            .gesture(DragGesture()
                .onEnded { value in
                    taskCardManager.deleteTask(index: index, value: value)
                }
            )

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
                
                TaskCardListView().environmentObject(taskCardManager)
                
                // キーボード入力がしやすいように持ち上げ
                Color.clear.frame(width:15, height: 300)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // task を追加
                    Button(action: {
                        self.taskCardManager.appendTask()
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
struct PlanDoPage_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoView()
    }
}

