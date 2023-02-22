//
//  DateTimeUtils.swift
//  1weekPDCA
//
//  Created by 齊藤虎太郎 on 2023/02/19.
//

import Foundation
import SwiftUI

// MARK: 日付表示の関数関係
struct DateTimeUtils {
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
    
    // 今年の残りの日数を返す関数
    func daysLeftInYear() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let endOfYear = calendar.date(bySetting: .month, value: 12, of: now)!
            .addingTimeInterval(24 * 60 * 60) // 12月31日の翌日の0時に設定
        let daysLeft = calendar.dateComponents([.day], from: now, to: endOfYear).day!
        return daysLeft
    }
    
    // 今年の日数を返す関数
    func numberOfDaysInCurrentYear() -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        // 閏年かどうかを判別
        if currentYear % 4 == 0 {
            if currentYear % 100 == 0 {
                if currentYear % 400 == 0 {
                    return 366
                } else {
                    return 365
                }
            } else {
                return 366
            }
        } else {
            return 365
        }
    }
    
}
