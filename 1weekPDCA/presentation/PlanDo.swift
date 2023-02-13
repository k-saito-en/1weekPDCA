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








struct WeekProgressBarCard: View {
    let today = Date()
    let calendar = Calendar.current


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 200)
                .foregroundColor(.white)

            VStack(spacing: 20) {
                HStack {
                    let (monday, sunday) = getWeekRange()
                    Text("\(calendar.component(.month, from: monday))/\(calendar.component(.day, from: monday)) - \(calendar.component(.month, from: sunday))/\(calendar.component(.day, from: sunday))")
                        .font(.headline)
                    Spacer()
                }

                HStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 250, height: 20)
                            .foregroundColor(.gray)

                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 150, height: 20)
                            .foregroundColor(.blue)
                    }

                    Spacer()
                }
            }
            .padding()
        }
    }
}


struct PlanDoPage_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            // ここに他のViewを配置
            WeekProgressBarCard()
            Spacer(minLength: 0)
        }
    }
}
