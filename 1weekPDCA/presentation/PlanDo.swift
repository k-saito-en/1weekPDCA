//
//  PlanDo.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/13.
//

import Foundation
import SwiftUI

//MARK: コンポーネント

// プログレスバーの実装
struct CustomProgressBar: View {
    
    let colorUtils = ColorUtils()
    
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Rectangle().frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: 10)
                    .foregroundColor(colorUtils.getProgressColor(for: progress))
                    .animation(.easeInOut, value: progress)
                
            }.cornerRadius(45.0)
        }
    }
}

// プログレスサークルの実装
struct customProgressCircle: View {
    
    let colorUtils = ColorUtils()
    
    var circleProgress: Double
    
    var body: some View {
        ZStack {
            // 背景の円
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(Color.uiColorGray)

            // 進捗を示す円
            Circle()
                .trim(from: 0.0, to: min(circleProgress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(colorUtils.getProgressColor(for: circleProgress))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut, value: circleProgress) // アニメーションを追加
            
            // 一回り小さな円
            Circle()
                .fill(colorUtils.getProgressColor(for: circleProgress).opacity(0.5))
                .frame(width: 35, height: 35)
                .animation(.easeInOut, value: circleProgress)
        }
    }
}

//MARK: UIカードの実装

// 全体の進捗表示、日付表示のカード
struct WeekProgressBarCardView: View {
    @EnvironmentObject var taskCardManager: TaskCardManager
    
    let dateTimeUtils = DateTimeUtils()
    
    let caluculateProgressUtils = CalculateProgressUtils()
    
    let today = Date()
    let calendar = Calendar.current
    
    var body: some View {
        let weekProgress = caluculateProgressUtils.calculateWeekProgress(taskCardData: taskCardManager.taskCardData)
        let weekRange = dateTimeUtils.getWeekRange()
        
        CardView {
            HStack {
                Text(dateTimeUtils.formatWeekRangeText(weekRange))
                    .textStyle(for: .title, color: Color.uiColorGray)
                
                Spacer()
                
                Text("\(dateTimeUtils.daysLeftInYear()) days left")
                    .textStyle(for: .title, color: Color.uiColorGray)
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

// タスク表示・todo表示のカード
struct TaskCardListView: View {
    
    @EnvironmentObject var taskCardManager: TaskCardManager
    
    let colorUtils = ColorUtils()
    let caluculateProgressUtils = CalculateProgressUtils()
    
    var body: some View {
        if taskCardManager.taskCardData.isEmpty {
            
            NoTaskView()
                
        } else {
            ForEach(taskCardManager.taskCardData.indices, id: \.self) { taskIndex in
                CardView {
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                            Button(action: {
                                taskCardManager.deleteTask(taskIndex: taskIndex, taskCardManager: taskCardManager)
                            }) {
                                
                                ZStack {
                                
                                    Color.clear.frame(width: 20, height: 10)
                                    
                                    Image(systemName: "minus")
                                        .resizable()
                                        .frame(width: 15, height: 3)
                                        .foregroundColor(Color.uiColorGray).opacity(0.5)
                                }
                                
                            }
                            .shadow(radius: 5)
                            
                            
                        }
                        
                        HStack {
                            // 30文字までに制限？
                            TextField(
                                "task title",
                                text: $taskCardManager.taskCardData[taskIndex].taskTitle,
                                axis: .vertical
                            )
                            .textStyle(for: .title, color: .uiColorGray)
                            .fixedSize(horizontal: false, vertical: true)
                            .onChange(
                                of: taskCardManager.taskCardData[taskIndex].taskTitle,
                                perform: { newValue in
                                    taskCardManager.updateTaskTitle(
                                        taskIndex: taskIndex,
                                        newTaskTitle: newValue,
                                        taskCardManager: taskCardManager
                                    )
                                }
                            )
                            
                            Spacer()
                            
                            customProgressCircle(circleProgress: caluculateProgressUtils.caluculateCircleProgress(index: taskIndex, taskCardManager: taskCardManager))
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 20)
                            
                        }
                        
                        // 空のViewを追加し、高さを10の隙間を開ける
                        Color.clear.frame(height: 10)
                        
                        // 追加された todo カードを表示する
                        ForEach(taskCardManager.taskCardData[taskIndex].todoData.indices, id: \.self) { todoIndex in
                            // todo カードの実装
                            HStack {
                                Spacer()
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(maxWidth: UIScreen.main.bounds.width / 10 * 7, maxHeight: .infinity)
                                        .foregroundColor(colorUtils.getIsDoneColor(for: taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone))
                                    
                                    HStack {
                                        // ラジオボタンの実装
                                        Image(systemName: taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(colorUtils.getIsDoneColor(for: taskCardManager.taskCardData[taskIndex].todoData[todoIndex].isDone))
                                            .onTapGesture {
                                                taskCardManager.toggleTodoDoneState(taskIndex: taskIndex, todoIndex: todoIndex, taskCardManager: taskCardManager)
                                            }
                                        
                                        
                                        VStack {
                                            Color.clear.frame(width:10, height: 4)
                                            
                                            TextField("ToDo", text: $taskCardManager.taskCardData[taskIndex].todoData[todoIndex].todoText, axis: .vertical)
                                                .textStyle(for: .body, color: .uiColorWhite)
                                                .frame(width: UIScreen.main.bounds.width / 10 * 5)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .onChange(
                                                    of: taskCardManager.taskCardData[taskIndex].todoData[todoIndex].todoText,
                                                    perform: { newValue in
                                                        taskCardManager.updateTodoText(
                                                            taskIndex: taskIndex,
                                                            todoIndex: todoIndex,
                                                            newTodoText: newValue,
                                                            taskCardManager: taskCardManager
                                                        )
                                                    }
                                                )
                                            
                                            Color.clear.frame(width:10, height: 4)
                                        }
                                        
                                        Button(action: {
                                            taskCardManager.deleteTodo(taskIndex: taskIndex, todoIndex: todoIndex, taskCardManager: taskCardManager)
                                        }) {
                                            
                                            ZStack {
                                                
                                                Color.clear.frame(width: 20, height: 10)
                                                
                                                Image(systemName: "minus")
                                                    .foregroundColor(Color.uiColorGray).opacity(0.5)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                // 新しいToDoカードを追加する
                                taskCardManager.createTodo(taskIndex: taskIndex, taskcardManager: taskCardManager)
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
    }
}

// 画面上にタスクカードがない場合のUI表示
struct NoTaskView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 70)
            
            Image("robot_image")
                .renderingMode(.original).opacity(0.3)
                .frame(width: UIScreen.main.bounds.width / 10 * 7, height: UIScreen.main.bounds.width / 10 * 7)
            
            Color.clear.frame(width:15, height: 40)
            
            Text("Make a plan!!")
                .textStyle(for: .progressCircle, color: Color.uiColorGray)
            
            Spacer()
        }
        .ignoresSafeArea()
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
                
                TaskCardListView().environmentObject(taskCardManager).onAppear(perform: taskCardManager.reloadTaskCardData)
                
                // キーボード入力がしやすいように持ち上げ
                Color.clear.frame(width:15, height: 150)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // task を追加
                    Button(action: {
                        taskCardManager.createTask(taskCardManager: taskCardManager)
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
                
                Color.clear.frame(width:15, height: 40)
            }
        }
        .ignoresSafeArea()
        .environmentObject(taskCardManager)
    }
}



//MARK: プレビューの設定
struct PlanDoPage_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoView()
    }
}

