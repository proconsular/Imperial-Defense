//
//  Imperial_Defense_Tests.swift
//  Imperial Defense Tests
//
//  Created by Chris Luttio on 1/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import XCTest
@testable import Imperial_Defense

class MainTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTransform() {
        let a = Transform(float2(1, 2), 0)
        XCTAssert(a.location.x == 1)
        XCTAssert(a.location.y == 2)
    }
    
    func testGenerator() {
        let generator = WaveGenerator()
        
        measure {
            let _ = generator.generate()
        }
    }
    
    func testTextureLoadTime() {
        measure {
            let _ = GLTextureLibrary()
        }
    }
    
    
    
}
