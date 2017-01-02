//
//  Sky_s_Melody_Tests.swift
//  Sky's Melody Tests
//
//  Created by Chris Luttio on 8/8/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import XCTest
@testable import Defender

class Sky_s_Melody_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testMain() {
        let transformtester = TransformTester()
        transformtester.testGlobal()
    }
    
}

class TransformTester {
    
    func testGlobal() {
        let aloc = float2(10, 15), bloc = float2(30, 10)
        let base = Transform(aloc)
        let parent = Transform(bloc)
        base.assign(parent)
        XCTAssert(base.global.location == (aloc + bloc))
        XCTAssert(base.location != base.global.location)
        let add = float2(30, 0)
        parent.location += add
        XCTAssert(base.global.location == (aloc + bloc + add))
    }
    
}
