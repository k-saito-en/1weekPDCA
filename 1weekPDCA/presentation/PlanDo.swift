//
//  PlanDo.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/13.
//

import Foundation
import SwiftUI

import Foundation

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






struct WeekProgressBarCard: View {
    let today = Date()
    let calendar = Calendar.current

    var body: some View {
        let weekRange = getWeekRange()
        let progress = 0.5 // 現時点ではモック化のために0.5に設定
        
        ZStack {
            
            Rectangle()
                .fill(Color.cardColorGray)
                .cornerRadius(25)
                .padding(Edge.Set.horizontal, 25)
                .frame(width: UIScreen.main.bounds.width, height: 110)
            
            VStack(spacing: 20) {
                HStack {
                    let (_, _) = getWeekRange()
                    Text(formatWeekRangeText(weekRange))
                        .font(.headline)
                    Spacer()
                }
                
                HStack {
                    ProgressView(value: progress)
                        .frame(width: 250, height: 20)
                        .progressViewStyle(LinearProgressViewStyle())
                    Spacer()
                }
            }
//            .background(Color.uiColorGray)
//            .cornerRadius(10)
            .padding(Edge.Set.horizontal, 50)
            .frame(width: UIScreen.main.bounds.width, height: 100)
        }
    }
}



struct PlanDoPage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backGroundColorGray.ignoresSafeArea() // ここで背景色を指定する
            VStack {
                WeekProgressBarCard()
                Spacer(minLength: 0)
                // 他のViewを追加する
            }
        }
    }
}
