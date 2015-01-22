//
//  SwiftUtilities_Tests.swift
//  SwiftUtilities Tests
//
//  Created by Zhang Yungui on 8/12/14.
//  Copyright (c) 2014 github.com/rhcad. All rights reserved.
//

import Cocoa
import XCTest
import SwiftUtilities

class SwiftUtilities_Tests: XCTestCase {
    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
    
    func testCGPointExtensions() {
        let value1 = CGPoint(x:10)
        XCTAssertNotEqual(value1, CGPointZero)
        XCTAssertEqual(value1, CGPoint(x:10, y:0))

        let value2 = value1 + CGPoint(y:20)
        XCTAssertEqual(value2, CGPoint(x:10, y:20))
    
        let value3 = value2 * 2
        XCTAssertEqual(value3, CGPoint(x:20, y:40))

        let value4 = value3 - CGPoint(x:1, y:1)
        XCTAssertEqual(value4, CGPoint(x:19, y:39))
    }
    
    func testCGSizeExtensions() {
        let value1 = CGSize(width:10)
        XCTAssertNotEqual(value1, CGSizeZero)
        XCTAssertEqual(value1, CGSize(width:10, height:0))

        let value2 = value1 + CGSize(height:20)
        XCTAssertEqual(value2, CGSize(width:10, height:20))
    
        let value3 = value2 * 2
        XCTAssertEqual(value3, CGSize(width:20, height:40))
    }

    func testCGRectExtensions() {
        let value1 = CGRect(width:100, height:200)
        XCTAssertEqual(value1, CGRect(x:0, y:0, width:100, height:200))
        
        let value2 = CGRect(size:CGSize(width:100,height:200))
        XCTAssertEqual(value2, CGRect(x:0, y:0, width:100, height:200))
    }

    func testQuadrants() {
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:10, y:10)), Quadrant.TopRight)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:-10, y:10)), Quadrant.TopLeft)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:10, y:-10)), Quadrant.BottomRight)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:-10, y:-10)), Quadrant.BottomLeft)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:0, y:0)), Quadrant.TopRight)

        let origin = CGPoint(x:10, y:10)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:15, y:15), origin:origin), Quadrant.TopRight)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:5, y:15), origin:origin), Quadrant.TopLeft)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:15, y:5), origin:origin), Quadrant.BottomRight)
        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:5, y:5), origin:origin), Quadrant.BottomLeft)

        let rect = CGRect(width:100, height:50)

        XCTAssertEqual(Quadrant.fromPoint(CGPoint(x:15, y:15), rect:rect), Quadrant.BottomLeft)
        
        XCTAssertEqual(Quadrant.TopRight.quadrantRectOfRect(rect), CGRect(x:50, y:25, width: 50, height:25))
        XCTAssertEqual(Quadrant.BottomLeft.quadrantRectOfRect(rect), CGRect(x:0, y:0, width: 50, height:25))
    }
    
    func testBoolEnum() {
        let b = BoolEnum(false)
        XCTAssertEqual(b, false)
        XCTAssertEqual(b, BoolEnum.False)
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
