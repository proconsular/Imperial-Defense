//
//  Upgrades.swift
//  Defender
//
//  Created by Chris Luttio on 10/14/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Upgrade {
    var name: String
    var range: PointRange
    
    init(_ name: String) {
        self.name = name
        range = PointRange(10)
        range.amount = 0
    }
    
    func upgrade() {
        range.increase(1)
    }
    
    func computeCost() -> Int {
        return Int(20 + 20 * range.amount)
    }
    
}

class BulletUpgrade: Upgrade {
    
    func computeInfo() -> BulletInfo! {
        return nil
    }
    
    override func computeCost() -> Int {
        return super.computeCost() + Int(20 * Float(Data.info.weapon))
    }
    
    override func upgrade() {
        super.upgrade()
        Data.info.weapon += 1
        Data.persist()
    }
    
}

class SniperBulletUpgrade: BulletUpgrade {
    
    init() {
        super.init("Sniper")
    }
    
    override func computeInfo() -> BulletInfo! {
        return BulletInfo(Int(20 * range.percent), 10.m * range.percent, 0, float2(0.6.m, 0.08.m), float4(1, 1, 0, 1))
    }
    
}

class MachineGunUpgrade: BulletUpgrade {
    
    init() {
        super.init("Machine")
    }
    
    override func computeInfo() -> BulletInfo! {
        return BulletInfo(Int(3 * range.percent), 0, -(0.2 * range.percent), float2(0.6.m, 0.08.m), float4(1, 1, 0, 1))
    }
    
}

class BombGunUpgrade: BulletUpgrade {
    
    init() {
        super.init("Bomb")
    }
    
    override func computeInfo() -> BulletInfo! {
        var info = BulletInfo(Int(5 * range.percent), 0, 0, float2(0.6.m, 0.08.m), float4(1, 1, 0, 1))
        info.collide = {
            let actors = Map.current.getActors(rect: FixedRect($0.body.location, float2(2.m * self.range.percent)))
            for a in actors {
                if let s = a as? Soldier {
                    s.damage(amount: Int(10 * self.range.percent))
                }
            }
            Map.current.append(Explosion($0.body.location, 2.m * self.range.percent))
        }
        return info
    }
    
}

class HealthUpgrade: Upgrade {
    
    init() {
        super.init("Shield")
    }
    
    func computeAmount() -> Int {
        return Int(300 * range.percent)
    }
    
}

class BarrierUpgrade: Upgrade {
    
    init() {
        super.init("Barrier")
    }
    
    func computeAmount() -> Int {
        return Int(125 * range.percent)
    }
    
}

class MovementUpgrade: Upgrade {
    
    init() {
        super.init("Movement")
    }
    
    func computeSpeed() -> Float {
        return 10.m * range.percent
    }
    
}


















