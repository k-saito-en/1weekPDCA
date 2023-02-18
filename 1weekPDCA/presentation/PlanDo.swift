//
//  PlanDo.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/13.
//

import Foundation
import SwiftUI


class TaskCardsManager: ObservableObject {
    
    @Published var taskCardsData = [
        (
            taskCard: TaskCardView,
            doneCount: Double,
            todoCount: Double
        )
    ]()
}



//MARK: プログレスバー・サークル関係

// 色変更ロジックのまとめ
struct ColorUtils {
    // プログレスバー・サークルの色変更関数
    static func getProgressColor(for progress: Double) -> Color {
        switch progress {
        case 0..<0.5:
            return Color.uiColorRed
        case 0.5...0.70:
            return Color.uiColorYellow
        default:
            return Color.uiColorGreen
        }
    }
}

// プログレスバーの実装 : Viewに準拠しているので,frame()でサイス指定できるようになった
struct CustomProgressBar: View {
    var progress: Double
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.uiColorGray)
                
                Rectangle().frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 10)
                    .foregroundColor(getBarColor(for: self.progress))
            }.cornerRadius(45.0)
        }
    }
    
    func getBarColor(for progress: Double) -> Color {
        return ColorUtils.getProgressColor(for: progress)
    }
}

// プログレスサークルの実装
struct customProgressCircle: View {
    let circleProgress: Double
    
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
                .foregroundColor(getCircleColor(for: circleProgress))
                .rotationEffect(Angle(degrees: 270.0))
            
            // 一回り小さな円
            Circle()
                .fill(getCircleColor(for: circleProgress).opacity(0.5))
                .frame(width: 35, height: 35)
        }
    }
    // customProgressCircleのgetCircleColor関数
    func getCircleColor(for progress: Double) -> Color {
        return ColorUtils.getProgressColor(for: progress)
    }
}

// MARK: 日付表示の関数関係

// 月曜日の0時0分0秒を返す関数
func getMondayOfCurrentWeek() -> Date {
    // current プロパティを呼び出して、システム時間に基づくカレンダーインスタンスを取得
    let calendar = Calendar.current
    // 現在の日付から「年・週」の情報を取得
    var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
    // 月曜日の情報を設定
    components.weekday = 2
    // DateComponents 型変数の components から Date 型のインスタンスを作成
    let monday = calendar.date(from: components)!
    return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: monday)!
}

// その週の月曜日の0時0分0秒と日曜日の23時59分59秒を返す関数
func getWeekRange() -> (monday: Date, sunday: Date) {
    let calendar = Calendar.current
    let monday = getMondayOfCurrentWeek()
    // 月曜日の日付を基に、6日加算した日付、つまり、日曜日を取得
    let sunday = calendar.date(byAdding: .day, value: 6, to: monday)!
    
    let sundayEndOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: sunday)!
    return (monday, sundayEndOfDay)
}

// weekRange を引数に、その週の一週間の日付を文字列で返す関数
func formatWeekRangeText(_ weekRange: (monday: Date, sunday: Date)) -> String {
    let calendar = Calendar.current
    return "\(calendar.component(.month, from: weekRange.monday))/\(calendar.component(.day, from: weekRange.monday)) - \(calendar.component(.month, from: weekRange.sunday))/\(calendar.component(.day, from: weekRange.sunday))"
}


//MARK: UICard 関係

struct WeekProgressBarCardView: View {
    @EnvironmentObject var taskCardsManager: TaskCardsManager
    
    var totalDoneCount: Double {
        taskCardsManager.taskCardsData.map { $0.doneCount }.reduce(0, +)
    }
    
    var totalTodoCount: Double {
        taskCardsManager.taskCardsData.map { $0.todoCount }.reduce(0, +)
    }
    
    var progress: Double {
        if totalTodoCount == 0 {
            return 0.0
        }
        return totalDoneCount / totalTodoCount
    }
    
    let today = Date()
    let calendar = Calendar.current
    
    var body: some View {
        let weekRange = getWeekRange()
        
        CardView {
            HStack {
                Text(formatWeekRangeText(weekRange))
                    .textStyle(for: .title, color: Color.uiColorGray)

                Spacer()
            }
            
            HStack {
                Spacer()
                CustomProgressBar(progress: totalDoneCount / totalTodoCount)
                    .frame(height: 20)
                Spacer()
            }
        }
        .frame(height: 120)
    }
}







struct TaskCardView: View, Equatable {
    let id: UUID
    
    static func == (lhs: TaskCardView, rhs: TaskCardView) -> Bool {
        // `id`が一致する場合にはtrueを返す
        return lhs.id == rhs.id
    }
    
    @EnvironmentObject var taskCardsManager: TaskCardsManager
    
    @State private var taskTitle = ""
    @State private var cardHeight: CGFloat = 120 // 初期値を設定
    // ToDoカードの配列　タプルで管理している
    @State private var todos: [(text: String, isDone: Bool)] = [] {
            didSet {
                let doneCount = Double(todos.filter { $0.isDone }.count)
                let totalCount = Double(todos.count)
                let progress = doneCount / totalCount

                taskCardsManager.taskCardsData[index].doneCount = Double(todos.filter { $0.isDone }.count)
                taskCardsManager.taskCardsData[index].todoCount = Double(todos.count)
            }
        }

        var index: Int {
            taskCardsManager.taskCardsData.firstIndex { $0.taskCard == self }!
        }
    

    var circleProgress: Double {
        guard !todos.isEmpty else {
            return 0.0
        }
        let doneCount = Double(todos.filter { $0.isDone }.count)
        let totalCount = Double(todos.count)
        let progress = doneCount / totalCount
        return progress
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
                    let taskBinding = Binding<String>(
                        get: {
                            todos[index].text
                        },
                        set: { newText in
                            todos[index].text = newText
                        }
                    )
                    HStack {
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
struct PlanDoPage_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoView()
    }
}

