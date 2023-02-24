//
//  _weekPDCA_Tests.swift
//  1weekPDCA_Tests
//
//  Created by 齊藤虎太郎 on 2023/02/22.
//



import XCTest
@testable import _weekPDCA


class BottomBarTests: XCTestCase {
    
    var bottomBar: BottomBar!
        
    override func setUp() {
        super.setUp()
        bottomBar = BottomBar()
    }

    override func tearDown() {
        bottomBar = nil
        super.tearDown()
    }

    
    func testBottomBar_hasThreeTabItems() {
        // 3つのタブが表示されていることを確認する
        let tabItemsCount = bottomBarItems.count
        XCTAssertEqual(tabItemsCount, 3)
    }
    
    func testBottomBar_selectedIndexInitialValue_isZero() {
        // 最初は0番目のタブが選択されていることを確認する
        XCTAssertEqual(bottomBar.selected, 0)
    }
    
    func testBottomBar_selectTab_changesSelectedIndex() {
        // タブを選択した時、選択されたタブのindexがselectedに代入されることを確認する
        bottomBar.selected = 1
        XCTAssertEqual(bottomBar.selected, 1)
        bottomBar.selected = 2
        XCTAssertEqual(bottomBar.selected, 2)
    }
    
    func testBottomBar_tabItemSelected_setsIsBig() {
        // タブが選択された時、isBigがtrueになることを確認する
        XCTAssertFalse(bottomBar.isBig)
        bottomBar.selected = 1
        XCTAssertTrue(bottomBar.isBig)
    }
    
    func testBottomBar_tabItemUnselected_resetsIsBig() {
        // タブが選択されなくなった時、isBigがfalseになることを確認する
        bottomBar.selected = 1
        XCTAssertTrue(bottomBar.isBig)
        bottomBar.selected = 0
        XCTAssertFalse(bottomBar.isBig)
    }
    
}
