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

//MARK: ボトムバー
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

//MARK: プログレスバー
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

//MARK: プログレスサークル
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

//MARK: 日付表示カード
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

//MARK: task カード

class TaskCardListViewTests: XCTestCase {
    
    let taskCardManager = TaskCardManager()

    // タスクが存在しない場合の画面表示をテスト
    func testNoTaskViewIsDisplayedWhenThereAreNoTasks() throws {
        // NoTaskViewが表示されるかどうかをテストする
        let taskCardView = TaskCardListView().environmentObject(taskCardManager)
        
        // 画像表示があるかどうか
        _ = try taskCardView.inspect().find(NoTaskView.self).vStack().image(1)
        
        // テキスト表示があるかどうか
        _ = try taskCardView.inspect().find(NoTaskView.self).vStack().text(3)
    }
    
    
    // タスクが存在する場合の画面表示をテスト
    func testAppendTask() throws {
        
        // タスク追加動作をはさむ
        taskCardManager.appendTask()
        let taskCardView = TaskCardListView().environmentObject(taskCardManager)

        
        let sut = try taskCardView.inspect().findAll(CardView<AnyView>.self)

        
        XCTAssertEqual(sut.count, taskCardManager.taskCardData.count)
        
    }
    
    // todo 追加されているかテスト
    func testAppendTodo() throws {
        
        // todo 追加動作をはさむ
        taskCardManager.appendTask()
        taskCardManager.appendTodo(index: 0)
        let taskCardView = TaskCardListView().environmentObject(taskCardManager)

        
        let sut = try taskCardView.inspect().forEach(0).find(CardView<AnyView>.self).zStack().vStack(0).vStack(1).forEach(2)

        
        XCTAssertEqual(sut.count, taskCardManager.taskCardData[0].todoData.count)
        
    }
    
    // task が削除されているかテスト
    func testDeleteTask() throws {
            
        // task を 3 回追加
        for _ in 0 ... 3 {
            taskCardManager.appendTask()
        }
        
        // task カードを右にドラッグした際のジェスチャー情報をスタブ化
        let dummyValue = DragGesture.Value(
            time: Date().addingTimeInterval(-0.5),
            location: .init(x: 20.0, y: 0),
            startLocation: .zero,
            velocity: .zero
        )

        taskCardManager.deleteTask(index: 0, value: dummyValue)
        
        let taskCardView = TaskCardListView().environmentObject(taskCardManager)
        let taskCards = try taskCardView.inspect().forEach(0)
        
        XCTAssertEqual(taskCards.count, taskCardManager.taskCardData.count)
    }

    // todo が削除されているかテスト
    func testDeleteTodo() throws {
        
        // task カードを追加
        taskCardManager.appendTask()
        
        // todo を 5 回追加
        for _ in 0 ... 5 {
            taskCardManager.appendTodo(index: 0 )
        }
        
        // task カードを右にドラッグした際のジェスチャー情報をスタブ化
        let dummyValue = DragGesture.Value(
            time: Date().addingTimeInterval(-0.5),
            location: .init(x: 20.0, y: 0),
            startLocation: .zero,
            velocity: .zero
        )
        
        taskCardManager.deleteTodo(index: 0, todoIndex: 1, value: dummyValue)
        
        let taskCardView = TaskCardListView().environmentObject(taskCardManager)
        let todoCards = try taskCardView.inspect().forEach(0).find(CardView<AnyView>.self).zStack().vStack(0).vStack(1).forEach(2)
        
        XCTAssertEqual(todoCards.count, taskCardManager.taskCardData[0].todoData.count)
        
    }

}


//MARK: テスト用の関数群
struct testFunctions {
    
    // 前の月曜日の日付を取得
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
    
    // 次の日曜日の日付を取得
    func getNextSunday() -> String {
        let calendar = Calendar.current
        let today = Date()
        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let nextSunday = calendar.date(byAdding: .day, value: 7, to: sunday)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: nextSunday)
    }
    
    // その年の残りの日数を取得
    func remainingDaysOfYear() -> String {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!
        let daysRemaining = calendar.dateComponents([.day], from: today, to: endOfYear).day!
        return "\(daysRemaining)"
    }

    
}
