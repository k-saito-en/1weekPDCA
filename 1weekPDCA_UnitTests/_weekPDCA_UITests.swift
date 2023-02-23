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
    
    let colorUtils = ColorUtils()
    
    func testCustomProgressBarBackGroundColor() throws {
        // set the initial progress value
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



