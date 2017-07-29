//
//  Weapon.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Weapon {
    
    var transform: Transform
    var direction: float2
    var offset: float2 = float2()
    
    var firer: Firer
    
    init(_ transform: Transform, _ direction: float2, _ firer: Firer) {
        self.transform = transform
        self.direction = direction
        self.firer = firer
    }
    
    func update() {
        firer.update()
    }
    
    func fire() {
        firer.fire(firepoint, direction)
    }
    
    var firepoint: float2 {
        return transform.location + 0.75.m * direction + offset
    }
    
    var canFire: Bool {
        return firer.operable
    }
    
}

class HomingWeapon: Weapon {
    
    func fire(_ target: Entity) {
        if let firer = firer as? HomingFirer {
            firer.fire(transform.location + 0.75.m * direction + offset, target)
        }
    }
    
}

class PlayerWeaponDisplayAdapter: StatusItem {
    
    var weapon: PlayerWeapon
    var warnings: [PowerWarning]
    
    init(_ weapon: PlayerWeapon) {
        self.weapon = weapon
        warnings = []
    }
    
    var percent: Float {
        return weapon.percent
    }
    
    var color: float4 {
        var c = weapon.color
        warnings.forEach{ c = $0.apply(c) }
        return c
    }
    
    func update() {
        warnings.forEach{ $0.update(percent) }
    }
    
}

class WeaponLowPowerWarning: ShieldLowPowerWarning {
    
    override func notify() {
        play("weapon_lowpower")
    }
    
}

struct Power {
    
    var amount: Float
    var limit: Float
    
    var recharge: Float
    var drain: Float
    
    init(_ limit: Float, _ recharge: Float, _ drain: Float) {
        self.limit = limit
        self.amount = limit
        self.recharge = recharge
        self.drain = drain
    }
    
    mutating func use() {
        amount = max(amount - drain, 0)
    }
    
    mutating func charge(_ mod: Float = 1) {
        if amount < limit {
            amount += recharge * mod * Time.delta
            amount = clamp(amount, min: 0, max: limit)
        }
    }
    
    var percent: Float {
        return amount / limit
    }
    
    var usable: Bool {
        return amount >= drain
    }
    
}

class PlayerWeapon: Weapon {
    
    var power: Power
    
    var rate_modifier: Float = 1
    
    var fired = true
    
    init(_ transform: Transform, _ direction: float2, _ power: Power, _ firer: Firer) {
        self.power = power
        super.init(transform, direction, firer)
    }
    
    var percent: Float {
        return power.percent
    }
    
    var color: float4 {
//        let red = rate_modifier > 1 ? 0.5 : 1
//        let green = rate_modifier < 1 ? 0.5 : 0
        return float4(1, 0, 0, 1)
    }
    
    override func update() {
        super.update()
       
        //firer.casing.size = float2(0.4.m, 0.12.m) * 1.2
        
        if isNormalPower {
            rate_modifier = 1
        }
        
        if isLowPower {
            rate_modifier = 2
        }
        
        if isHighPower {
            rate_modifier = 0.75
            
            //firer.casing.size = float2(0.4.m, 0.12.m) * 1.6
        }
        
        firer.impact.damage = 15
        if upgrader.firepower.range.percent == 1 {
            if random(0, 1) <= 0.1 {
                firer.impact.damage = 45
            }
        }
        
        power.charge(1 / rate_modifier)
        
        fired = false
    }
    
    var isNormalPower: Bool {
        return power.amount > power.drain
    }
    
    var isHighPower: Bool {
        return power.amount >= power.limit - power.drain
    }
    
    var isLowPower: Bool {
        return power.amount <= power.drain
    }
    
    override var canFire: Bool {
        return firer.counter >= firer.rate * rate_modifier && power.usable
    }
    
    override func fire() {
        super.fire()
        power.use()
        fired = true
    }
    
}

class Laser {
    
    var rect: Polygon
    var display: Display
    var transform: Transform
    var direction: float2
    var visible: Bool
    let bounds: float2
    
    var side: Display
    
    init(_ location: float2, _ width: Float, _ direction: float2) {
        self.transform = Transform(location)
        self.direction = direction
        bounds = float2(Camera.size.y * 1.5, width)
        rect = Polygon(self.transform, [float2(0, -bounds.y * 0.25), float2(0, bounds.y * 0.25), float2(bounds.x, bounds.y * 8), float2(bounds.x, -bounds.y * 8)])
        display = Display(rect, GLTexture("white"))
//        display.coordinates = [float2(0, 0), float2(1, 0), float2(1, 1), float2(0, 1)]
        display.color = float4(1, 0, 0, 1)
        side = Display(Rect(Transform(float2()), float2(Camera.size.y * 1.5, 50)), GLTexture("laser"))
        visible = false
    }
    
    func update() {
        let angle = atan2(direction.y, direction.x)
        let a = angle - 0.1
        let loc = transform.location
        rect.transform.location = loc + float2(bounds.x / 2, bounds.x / 2) * direction
        side.transform.location = loc + float2(bounds.x / 2, bounds.x / 2) * float2(cosf(a), sinf(a)) + float2(0.3.m, 0)
        rect.transform.orientation = angle
        side.transform.orientation = a
        let rand = arc4random() % 2
        display.color = rand == 0 ? float4(0.8, 0, 1, 1) : float4(0.4, 0, 0.4, 0.4)
        side.color = display.color
        side.refresh()
        display.visual.refresh()
        if visible {
            if display.color.w == 1 {
                let audio = Audio("laser2")
                audio.volume = sound_volume
                audio.start()
            }
        }
    }
    
    func render() {
        if visible {
           // let _ = Graphics.bind(4).setProperty("color", vector4: display.color)
            display.render()
//            side.render()
           // Graphics.bindDefault()
        }
    }
    
}





















