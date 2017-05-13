//
//  SoldierTypes.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Scout: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(5, nil), float4(0.5, 0.5, 0.5, 1))
        let firer = Firer(0.25, Impact(10, 8.m), Casing(float2(0.5.m, 0.14.m), float4(1, 0.75, 0, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        animator = BaseMarchAnimator(body, 0.05, 0.15.m)
        animator.apply(display)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
    
}

class Banker: Soldier {
    
    required init(_ location: float2) {
        let shield = Shield(Float(15), Float(2.0), Float(15))
        super.init(location, Health(45, shield), float4(1, 1, 0.25, 1))
        drop = CoinDrop(Int(arc4random() % 2) + 1, 1)
        behavior.base.append(MarchBehavior(self, animator))
    }
    
    override func update() {
        super.update()
        if transform.location.y < -Camera.size.y * 2 {
            alive = false
        }
    }
    
}

class Captain: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(30), Float(2.0), Float(30))), float4(1, 0.5, 0.5, 1))
        let firer = Firer(1.0, Impact(20, 6.m), Casing(float2(0.5.m, 0.14.m) * 1.2, float4(1, 0, 0, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(RushBehavior(transform, 4.m))
    }
    
}

class Healer: Soldier {
    
    var timer: Timer!
    
    required init(_ location: float2) {
        super.init(location, Health(15, Shield(Float(15), Float(1.0), Float(50))), float4(0.25, 1, 0.25, 1))
        timer = Timer(3) { [unowned self] in
            if random(0, 1) <= 0.1 {
                self.heal(2.m)
            }
        }
        behavior.base.append(MarchBehavior(self, animator))
    }
    
    override func update() {
        super.update()
        timer.update(Time.delta)
    }
    
    func heal(_ radius: Float) {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                soldier.health.shield?.points.increase(15)
            }
        }
        let ex = Explosion(transform.location, radius)
        ex.color = float4(0, 0, 1, 1)
        Map.current.append(ex)
    }
    
}

class Heavy: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(60), Float(2.0), Float(30))), float4(0.5, 0.5, 1, 1))
        let firer = Firer(1.5, Impact(30, 6.m), Casing(float2(0.5.m, 0.14.m) * 1.4, float4(1, 0, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
    
}

class Sniper: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(20), Float(0.5), Float(60))), float4(1, 0.5, 1, 1))
        let firer = Firer(2.0, Impact(50, 10.m), Casing(float2(0.6.m, 0.1.m), float4(0, 1, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
    }
    
}
