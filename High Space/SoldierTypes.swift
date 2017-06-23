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
        super.init(location, Health(5, nil), float4(1))
        let firer = Firer(0.25, Impact(10, 8.m), Casing(float2(0.4.m, 0.1.m), float4(1, 0.25, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Scout").id
        animator.set(1)
        
        sprinter = true
        
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
        canSprint = true
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
        super.init(location, Health(45, Shield(Float(60), Float(0.75), Float(50))), float4(1))
        let firer = Firer(1.0, Impact(20, 10.m), Casing(float2(0.7.m, 0.175.m), float4(1, 0.5, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Captain").id
        
        canSprint = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(RushBehavior(transform, 3.m))
    }
    
}

class Commander: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(90), Float(0.5), Float(50))), float4(1))
        let firer = Firer(1.0, Impact(30, 10.m), Casing(float2(0.7.m, 0.175.m), float4(1, 0.25, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Commander").id
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(AllfireBehavior(self))
        
    }
    
}

class Thief: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, nil), float4(1))
        let firer = Firer(1.0, Impact(5, 12.m), Casing(float2(0.4.m, 0.1.m), float4(1, 0.25, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Thief").id
        animator.set(1)
        
        sprinter = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(DodgeBehavior(self, 0.5))
    }
    
}

class Healer: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(15, Shield(Float(30), Float(0.1), Float(50))), float4(1))
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(HealBehavior(self))
        
        display.texture = GLTexture("Healer").id
    }
    
}

class Heavy: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(50, Shield(Float(50), Float(0.5), Float(50))), float4(1))
        let firer = Firer(1.5, Impact(30, 10.m), Casing(float2(0.5.m, 0.14.m) * 1.4, float4(1, 0, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Heavy").id
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(RapidFireBehavior(self))
    }
    
}

class Sniper: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(60), Float(0.5), Float(60))), float4(1))
        let firer = Firer(1.25, Impact(15, 25.m), Casing(float2(0.7.m, 0.15.m), float4(1, 0.5, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Sniper").id
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(DodgeBehavior(self, 0.4))
    }
    
    override func update() {
        super.update()
        weapon?.direction = normalize(Player.player.transform.location - transform.location)
    }
    
}

class Mage: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(40), Float(0.1), Float(60))), float4(1))
        let firer = HomingFirer(1, Impact(30, 18.m), Casing(float2(0.8.m, 0.15.m), float4(1, 0.5, 1, 1), "player"))
        weapon = HomingWeapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Mage").id
        display.coordinates = SheetLayout(0, 12, 3).coordinates
        display.refresh()
        
        behavior.base.append(GlideBehavior(self, 0.25.m))
        behavior.base.append(DodgeBehavior(self, 0.1))
        behavior.base.append(HomingShootBehavior(weapon!, self, Player.player))
    }
    
    override func update() {
        super.update()
        display.coordinates = SheetLayout(0, 12, 3).coordinates
    }
    
}

class Emperor: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, nil), float4(1))
        let firer = HomingFirer(1, Impact(0, 18.m), Casing(float2(0.8.m, 0.15.m), float4(1, 0.5, 1, 1), "player"))
        weapon = HomingWeapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.275.m, -0.5.m)
        
        display.texture = GLTexture("Emperor").id
        display.coordinates = SheetLayout(0, 12, 3).coordinates
        display.refresh()
        
        behavior.base.append(GlideBehavior(self, 0.25.m))
        behavior.base.append(DodgeBehavior(self, 0.1))
        behavior.base.append(HomingShootBehavior(weapon!, self, Player.player))
    }
    
    override func update() {
        super.update()
        display.coordinates = SheetLayout(0, 12, 3).coordinates
    }
    
}








