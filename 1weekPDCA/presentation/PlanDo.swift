//
//  PlanDo.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/13.
//

import Foundation
import SwiftUI

import Foundation

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
                    .foregroundColor(getBarColor(for: progress))
            }.cornerRadius(45.0)
        }
    }
    
    // CustomProgressBarのgetBarColor関数
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

            // 円形のプログレスバー
            ProgressView(value: circleProgress)
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 40, height: 40)
            
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

struct WeekProgressBarCard: View {
    let today = Date()
    let calendar = Calendar.current
    
    var body: some View {
        let weekRange = getWeekRange()
        let progress = 0.71 // モック化のために定数
        
        CardView {
            HStack {
                Text(formatWeekRangeText(weekRange))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.uiColorGray)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                CustomProgressBar(progress: progress)
                    .frame(height: 20)
                Spacer()
            }
        }
        .frame(height: 120)
    }
}


struct TaskCard: View {
    let circleProgress = 0.50 // モック化のために定数
    
    var body: some View {
        CardView {
            HStack {
                Text("タスクタイトルが入ります")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.uiColorGray)
                
                Spacer()
                
                customProgressCircle(circleProgress: circleProgress)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)

            }
        }
        .frame(height: 120)
    }
}

//MARK: PlanDo 画面全体の実装
struct PlanDoView: View {
    
    var body: some View {
        ZStack {
            Color.backGroundColorGray.ignoresSafeArea() // ここで背景色を指定する
            VStack {
                WeekProgressBarCard()
                TaskCard()
                Spacer(minLength: 0)
                // 他のViewを追加する
            }
        }
    }
}

//MARK: プレビューの設定
struct PlanDoPage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backGroundColorGray.ignoresSafeArea() // ここで背景色を指定する
            VStack {
                WeekProgressBarCard()
                TaskCard()
                Spacer(minLength: 0)
                // 他のViewを追加する
            }
        }
    }
}
