//
//  _weekPDCATests.swift
//  1weekPDCATests
//
//  Created by 齊藤虎太郎 on 2023/02/22.
//

import XCTest
@testable import _weekPDCA

import ViewInspector



class _weekPDCA_UnitTests: XCTestCase {
    
    func testBottomBar() throws {
        // ボトムバーを初期化
        let bottomBar = BottomBar()
        
        // テスト対象のViewが、全体のどの部分を占めているかを指定
        let vStack = try bottomBar.inspect().vStack(0)
        
        // タブビューの存在を確認
        let tabView = try vStack.tabView(0)
        XCTAssertEqual(tabView.count, 3)
        
        // タブビュー内のコンテンツの存在を確認
        for i in 0..<3 {
            let content = try tabView.view(MockActView.self, i)
            XCTAssertNotNil(content)
        }
        
        // タブの選択状態を確認
        XCTAssertEqual(tabView.startIndex, 0)
        
        // ボトムバーのボタンをタップして、タブの選択状態が変わることを確認
        for i in 0..<3 {
            try vStack.hStack(1).image(i).callOnTapGesture()
            XCTAssertEqual(bottomBar.selected, i)
        }
        
        // ボトムバーのボタンのレイアウトを確認
//        for i in 0..<3 {
//            let image = try vStack.hStack(1).image(i)
//            XCTAssertEqual(try image.actualImage().uiImage(), bottomBarItems[i].image)
//            XCTAssertEqual(try image.actualImage().foregroundColor(), .uiColorGray)
//            XCTAssertEqual(try image.actualImage().size().width, 30.0)
//            XCTAssertEqual(try image.actualImage().size().height, 30.0)
//        }
    }
    
}
