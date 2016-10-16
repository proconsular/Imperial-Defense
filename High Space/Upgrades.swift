//
//  Upgrades.swift
//  Defender
//
//  Created by Chris Luttio on 10/14/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class SniperBulletUpgrade {
    
    var range: PointRange
    
    init() {
        range = PointRange(10)
        range.amount = 0
    }
    
    func computeInfo() -> BulletInfo {
        return BulletInfo(Int(20 * range.percent), 40.m * range.percent, float2(0.6.m, 0.08.m), float4(1, 1, 0, 1))
    }
    
    func upgrade() {
        range.increase(1)
    }
    
}
