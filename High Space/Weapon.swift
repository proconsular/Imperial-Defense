//
//  Weapon.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct BulletInfo {
    
    var damage: Int
    var speed: Float
    var rate: Float
    
    var size: float2
    var color: float4
    
    var collide: (Bullet) -> () = {_ in}
    
    init(_ damage: Int, _ speed: Float, _ rate: Float, _ size: float2, _ color: float4) {
        self.damage = damage
        self.speed = speed
        self.rate = rate
        self.size = size
        self.color = color
    }
    
}

class Weapon {
    
    var transform: Transform
    var direction: float2
    var offset: float2 = float2()
    
    var tag: String
    
    var counter: Float = 0
    
    var bullet_data: BulletInfo
    
    init(_ transform: Transform, _ direction: float2, _ data: BulletInfo, _ tag: String) {
        self.transform = transform
        self.direction = direction
        self.bullet_data = data
        self.tag = tag
    }
    
    func update() {
        counter += Time.time
    }
    
    var canFire: Bool {
        return counter >= bullet_data.rate
    }
    
    func fire() {
        counter = 0
        let bullet = Bullet(transform.location + 0.75.m * direction + offset, direction, tag, bullet_data)
        if tag == "player" {
            bullet.body.mask = 0b11
        }else{
            bullet.body.mask = 0b100
        }
        Map.current.append(bullet)
    }
    
}

class PlayerWeapon: Weapon, StatusItem {
    
    var power: Float
    
    let drain: Float = 30
    let recharge: Float = 200
    let max_power: Float = 175
    
    var rate_modifier: Float = 1
    
    var fired = true
    
    override init(_ transform: Transform, _ direction: float2, _ data: BulletInfo, _ tag: String) {
        power = max_power
        super.init(transform, direction, data, tag)
    }
    
    func overcharge(amount: Float) {
        power = max_power * amount
    }
    
    var percent: Float {
        return power / max_power
    }
    
    var color: float4 {
        let red = rate_modifier > 1 ? 0.5 : 1
        let green = rate_modifier < 1 ? 0.5 : 0
        return float4(Float(red), Float(green), 0, 1)
    }
    
    override func update() {
        super.update()
       
        bullet_data.size = float2(0.4.m, 0.12.m) * 1.2
        
        if isNormalPower {
            rate_modifier = 1
        }
        
        if isLowPower {
            rate_modifier = 1.5
        }
        
        if isHighPower {
            rate_modifier = 0.75
            bullet_data.size = float2(0.4.m, 0.12.m) * 1.6
        }
        
        if power < max_power {
            power += recharge * (1.0 / rate_modifier) * Time.time
            power = clamp(power, min: 0, max: max_power)
        }
       
        fired = false
    }
    
    var isNormalPower: Bool {
        return power > drain
    }
    
    var isHighPower: Bool {
        return power >= max_power - drain
    }
    
    var isLowPower: Bool {
        return power <= drain
    }
    
    override var canFire: Bool {
        return counter >= bullet_data.rate * rate_modifier && power >= drain
    }
    
    override func fire() {
        super.fire()
        power -= drain
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
            power -= 2 * Time.time
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
            power += rate * Time.time
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






















