//
//  DummyTests.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import Cocoa
import XCTest
import SwiftGraphics
//import ShapeAnimation

class DummyTests: XCTestCase {

    func testOrientation() {
        XCTAssertEqual(CGSize(width:100, height:100).orientation, Orientation.Square)
    }

}
