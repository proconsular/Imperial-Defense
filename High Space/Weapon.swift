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
        firer.fire(transform.location + 0.75.m * direction + offset, direction)
    }
    
    var canFire: Bool {
        return firer.operable
    }
    
}

class PlayerWeaponDisplayAdapter: StatusItem {
    
    var weapon: PlayerWeapon
    
    init(_ weapon: PlayerWeapon) {
        self.weapon = weapon
    }
    
    var percent: Float {
        return weapon.percent
    }
    
    var color: float4 {
        return weapon.color
    }
    
    func update() {
        
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
        let red = rate_modifier > 1 ? 0.5 : 1
        let green = rate_modifier < 1 ? 0.5 : 0
        return float4(Float(red), Float(green), 0, 1)
    }
    
    override func update() {
        super.update()
       
        firer.casing.size = float2(0.4.m, 0.12.m) * 1.2
        
        if isNormalPower {
            rate_modifier = 1
        }
        
        if isLowPower {
            rate_modifier = 2
        }
        
        if isHighPower {
            rate_modifier = 0.75
            firer.casing.size = float2(0.4.m, 0.12.m) * 1.6
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
    
    var rect: Rect
    var display: Display
    var transform: Transform
    var direction: Int
    
    init(_ location: float2, _ width: Float, _ direction: Int) {
        self.transform = Transform(location)
        self.direction = direction
        let bounds = float2(width, Camera.size.y)
        rect = Rect(self.transform, bounds)
        display = Display(rect, GLTexture("white"))
        display.color = float4(1, 0, 0, 1)
    }
    
    func update() {
        rect.transform.location = transform.location - float2(0, rect.bounds.y / 2) * Float(direction)
        let rand = arc4random() % 2
        display.color = rand == 0 ? float4(0.8, 0, 1, 1) : float4(0.4, 0, 0.4, 0.4)
        display.visual.refresh()
    }
    
    func render() {
        display.render()
    }
    
}

class LaserWeapon: StatusItem {
    
    var laser: Laser
    var isFiring: Bool
    
    var limit: Float = 5
    var power: Float
    var usable: Bool
    
    var rate: Float = 0.25
    
    var callback: (Actor) -> ()
    
    init(_ laser: Laser, _ callback: @escaping (Actor) -> ()) {
        self.laser = laser
        self.callback = callback
        isFiring = false
        power = limit
        usable = true
    }
    
    var percent: Float {
        return power / 5
    }
    
    var color: float4 {
        return float4(0)
    }
    
    func fire() {
        isFiring = true
    }
    
    func update() {
        laser.update()
        if power >= limit {
            usable = true
        }
        if isFiring && usable {
            power -= 2 * Time.delta
            let actors = Map.current.getActors(rect: laser.rect.getBounds())
            for a in actors {
                callback(a)
            }
            if laser.display.color.w == 1 {
                play("laser2", 1)
            }
        }
        if !isFiring && usable {
            usable = false
        }
        if power <= 0 {
            usable = false
        }
        if !isFiring || !usable {
            power += rate * Time.delta
        }
        power = clamp(power, min: 0, max: limit)
    }
    
    func render() {
        if isFiring && usable {
            laser.render()
        }
        isFiring = false
    }
    
}






















