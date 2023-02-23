//
//  _weekPDCA_UITests.swift
//  1weekPDCA_UITests
//
//  Created by 齊藤虎太郎 on 2023/02/22.
//

import XCTest
import ViewInspector
import SwiftUI

@testable import _weekPDCA


class BottomBarTests: XCTestCase {
    
    // ボトムバーが存在するか
    // ボトムバーの初期表示画面が Act 画面かどうか
    func testBottomBarInitialState() {
        let bottomBar = BottomBar()
        XCTAssertEqual(bottomBar.selected, 0, "Initial selected value should be 0")
        XCTAssertFalse(bottomBar.isBig, "Initial isBig value should be false")
    }
    
    //
    func testBottomBarItemContent() {
        let bottomBarItems = bottomBarItems

        let testBottomBarItems = [
            BottomBarItem(image: "graduationcap.fill", view: AnyView(MockActView())),
            BottomBarItem(image: "square.fill", view: AnyView(PlanDoView())),
            BottomBarItem(image: "checkmark.circle.fill", view: AnyView(MockCheckView()))
        ]

        XCTAssertEqual(bottomBarItems.count, 3, "There should be 3 bottom bar items")

        for i in 0..<bottomBarItems.count {
            XCTAssertEqual(bottomBarItems[i].image, testBottomBarItems[i].image, "Item \(i) image should match")
        }
    }
    
    // Add more test cases as needed...
    
}

class CustomProgressBarTests: XCTestCase {
    
    func testCustomProgressBarBackGroundColor() throws {

        let progressBar = CustomProgressBar(progress: 0.5)
        
        // プログレスバーの背景色をテスト
        let backGroundSut = try progressBar.inspect().geometryReader().zStack().shape(0)
        
        XCTAssertEqual(try backGroundSut.foregroundColor(), Color.gray)

    }
    
    // 進捗によってバーの色が変わるかテスト
    func testCustomProgressBarProgressColor() throws {
        
        // テストケースをタプルで管理
        let testCases: [(progress: Double, expectedColor: Color)] = [
            (0.49, Color.uiColorRed),
            (0.69, Color.uiColorYellow),
            (0.70, Color.uiColorGreen)
        ]
        
        for testCase in testCases {
            
            let progressBar = CustomProgressBar(progress: testCase.progress)
            
            let sut = try progressBar.inspect().geometryReader().zStack().shape(1)
            
            XCTAssertEqual(try sut.foregroundColor(), testCase.expectedColor)
        }
    }
    
}

class CustomProgressCircleTests: XCTestCase {
    
    func testCustomProgressCircleBackGroundColor() throws{
        
        let progressCircle = customProgressCircle(circleProgress: 0.5)
        
        let backGroundSut = try progressCircle.inspect().zStack().shape(0)
        
        XCTAssertEqual(try backGroundSut.foregroundColor(), Color.uiColorGray)
        
    }
    
    func testCustomProgressCircleProgressColor() throws {
        
        // テストケースをタプルで管理
        let testCases: [(progress: Double, expectedColor: Color)] = [
            (0.49, Color.uiColorRed),
            (0.69, Color.uiColorYellow),
            (0.70, Color.uiColorGreen)
        ]
        
        for testCase in testCases {
            
            let progressCircle = customProgressCircle(circleProgress: testCase.progress)
            
            let sut = try progressCircle.inspect().zStack().shape(1)
            
            XCTAssertEqual(try sut.foregroundColor(), testCase.expectedColor)
        }
    }
    
    // 内円の色テスト追加しなきゃ
    
}

// テスト用の関数群
struct testFunctions {
    
    func getMondayDateString() -> String {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        var mondayComponents = DateComponents()
        if weekday == 2 { // 月曜日
            mondayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        } else {
            let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            mondayComponents.weekday = 2 // 月曜日
            mondayComponents.weekOfYear = calendar.component(.weekOfYear, from: weekStartDate)
            mondayComponents.yearForWeekOfYear = calendar.component(.yearForWeekOfYear, from: weekStartDate)
        }
        let monday = calendar.date(from: mondayComponents)!
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: monday)
    }
    
    func getNextSunday() -> String {
        let calendar = Calendar.current
        let today = Date()
        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let nextSunday = calendar.date(byAdding: .day, value: 7, to: sunday)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: nextSunday)
    }
    
    func remainingDaysOfYear() -> String {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!
        let daysRemaining = calendar.dateComponents([.day], from: today, to: endOfYear).day!
        return "\(daysRemaining)"
    }

    
}


class WeekProgressBarCardViewTests: XCTestCase {
    
    let taskCardManager = TaskCardManager()
    
    func testWeekRangeText() throws {
        
        let testFunctions = testFunctions()
        
        let weekProgressBarCardView = WeekProgressBarCardView().environmentObject(taskCardManager)
        
        // まずは存在確認
        let sut = try weekProgressBarCardView.inspect().find(CardView<AnyView>.self).zStack().vStack(0).tupleView(1).hStack(0).text(0)
        
        XCTAssertEqual(try sut.string(), "\(testFunctions.getMondayDateString()) - \(testFunctions.getNextSunday())")
        
    }
    
    func daysLeftInYearText() throws {
        
        let testFunctions = testFunctions()
        
        let weekProgressBarCardView = WeekProgressBarCardView().environmentObject(taskCardManager)
        
        let sut = try weekProgressBarCardView.inspect().find(CardView<AnyView>.self).zStack().vStack(0).tupleView(1).hStack(0).text(1)
        
        XCTAssertEqual(try sut.string(), "\(testFunctions.remainingDaysOfYear()) days left")
        
    }
}
