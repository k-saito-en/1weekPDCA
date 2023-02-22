//
//  _weekPDCA_UITests.swift
//  1weekPDCA_UITests
//
//  Created by 齊藤虎太郎 on 2023/02/22.
//

import XCTest

@testable import _weekPDCA
import ViewInspector
import SwiftUI

class BottomBarTests: XCTestCase {
    
    func testBottomBarInitialState() {
        let bottomBar = BottomBar()
        XCTAssertEqual(bottomBar.selected, 0, "Initial selected value should be 0")
        XCTAssertFalse(bottomBar.isBig, "Initial isBig value should be false")
    }
    
    func testBottomBarItemContent() {
        let bottomBarItems = [
            BottomBarItem(image: "graduationcap.fill", view: AnyView(MockActView())),
            BottomBarItem(image: "square.fill", view: AnyView(PlanDoView())),
            BottomBarItem(image: "checkmark.circle.fill", view: AnyView(MockCheckView()))
        ]
        
        XCTAssertEqual(bottomBarItems.count, 3, "There should be 3 bottom bar items")
        XCTAssertEqual(bottomBarItems[0].image, "graduationcap.fill", "First item image should be graduationcap.fill")
    }
    
    // Add more test cases as needed...
    
}



