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

class BulletTimeTest: XCTestCase {
    
    //Random Collisions take ~10ms
    func testRandomBulletCompareTime() {
        let map = Map(float2(20.m, 60.m))
        Map.current = map
        
        for _ in 0 ..< 40 {
            map.append(Bullet(float2(10.m, -20.m) + float2(random(-5.m, 5.m), 0), float2(0, 1), Impact(0, 0), Casing(float2(1.m, 0.5.m), float4(), "")))
        }
        
        for _ in 0 ..< 80 {
            map.append(Captain(float2(10.m, -20.m) + float2(random(-5.m, 5.m), 0)))
        }
        
        measure {
            map.updateBullets()
        }
    }
    
    //Direct Collisions take ~14ms
    func testDirectBulletCompareTime() {
        let map = Map(float2(20.m, 60.m))
        Map.current = map
        
        for _ in 0 ..< 40 {
            map.append(Bullet(float2(10.m, -20.m), float2(0, 1), Impact(0, 0), Casing(float2(1.m, 0.5.m), float4(), "")))
        }
        
        for _ in 0 ..< 80 {
            map.append(Captain(float2(10.m, -20.m)))
        }
        
        measure {
            map.updateBullets()
        }
    }
    
    //Separated (No Collisions) take ~8ms
    func testSeparatedBulletCompareTime() {
        let map = Map(float2(20.m, 60.m))
        Map.current = map
        
        for _ in 0 ..< 40 {
            let b = Bullet(float2(10.m, -15.m), float2(0, 1), Impact(0, 0), Casing(float2(1.m, 0.5.m), float4(), ""))
            map.append(b)
        }
        
        for _ in 0 ..< 80 {
            map.append(Captain(float2(10.m, -25.m)))
        }
        
        measure {
            map.updateBullets()
        }
    }
    
}

class UITest: XCTestCase {
    
    func testUIMenus() {
        UserInterface.space.wipe()
        UserInterface.push(Splash())
        UserInterface.space.wipe()
        UserInterface.push(Settings())
        UserInterface.space.wipe()
        UserInterface.push(PrincipalScreen())
    }
    
}














