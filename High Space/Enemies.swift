//
//  Enemies.swift
//  Defender
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Soldier: Actor {
    
    var weapon: Weapon!
    var rate: Float = 0.3
    var counter: Float = 0
    var health: Int = 4
    var weight: Int = 1
    
    init(_ location: float2) {
        super.init(Rect(location, float2(1.m, 1.25.m)), Substance.getStandard(100))
        rate = 0.3
        display.texture = GLTexture("soldier").id
        weapon = Weapon(transform, float2(0, 1), BulletInfo(1, 10.m, float2(0.4.m, 0.08.m), float4(1, 0, 0, 1)), "player")
        body.mask = 0b100
        body.object = self
    }
    
    override func update() {
        super.update()
        weapon.update()
        move()
        if health <= 0 {
            alive = false
            
            Score.points += weight
            
            death()
        }
    }
    
    func death() {
        let a = Audio("explosion1")
        a.volume = 1
        a.start()
        let c = arc4random() % 5 + 5
        for _ in 0 ..< c {
            let p = Particle(body.location, random(0.03.m, 0.05.m))
            let angle = random(-Float.pi, Float.pi)
            let mag = random(2, 6) * 1.m
            p.body.velocity = float2(cos(angle), sin(angle)) * mag
            Map.current.append(p)
        }
    }
    
    func move() {
        counter += Time.time
        if counter >= rate {
            counter = 0
            body.location.y += 0.1.m
            playIfNot("hit2", 0.8)
        }
    }
    
    func fire() {
        if weapon.canFire {
            weapon.fire()
            play("shoot2", 0.8)
        }
    }
    
}

class Captain: Soldier {
    
    var rage: Float
    var direction: Int = 1
    var width: Float = 10.m
    
    override init(_ location: float2) {
        rage = 0
        super.init(location)
        display.color = float4(0, 0, 1, 1)
        weapon.rate = 0.2
        health = 10
        weight = 10
    }
    
    override func update() {
        super.update()
        display.color = float4(rage, 0, 1 * (1 - rage), 1)
        display.visual.refresh()
        if rage >= 1 {
            if weapon.canFire {
                weapon.fire()
                play("shoot2", 0.8)
            }
        }
    }
    
    override func death() {
        let a = Audio("explosion1")
        a.volume = 1
        a.pitch = 0.8
        a.start()
        let c = arc4random() % 5 + 10
        for _ in 0 ..< c {
            let p = Particle(body.location, random(0.03.m, 0.05.m))
            p.color = float4(1, 0, 0, 1)
            let angle = random(-Float.pi, Float.pi)
            let mag = random(2, 6) * 1.m
            p.body.velocity = float2(cos(angle), sin(angle)) * mag
            Map.current.append(p)
        }
    }
    
    override func move() {
        if rage < 1 {
            super.move()
        }else{
            let left = Map.current.size.x / 2 - width / 2
            let right = Map.current.size.x / 2 + width / 2
            if body.location.x < left {
                direction = 1
            }
            if body.location.x > right {
                direction = -1
            }
            body.location.x += 0.125.m * Float(direction)
            body.location.y += 0.0075.m
        }
    }
    
    override func fire() {
       
    }
    
}

class Sniper: Soldier {
    
    override init(_ location: float2) {
        super.init(location)
        display.color = float4(1, 1, 0, 1)
        weapon.rate = 1
        health = 8
        weight = 5
        weapon.bullet_data = BulletInfo(5, 20.m, float2(0.6.m, 0.04.m), float4(1, 1, 0, 1))
    }
    
    override func death() {
        let a = Audio("explosion1")
        a.volume = 1
        a.pitch = 1.2
        a.start()
        let c = arc4random() % 5 + 10
        for _ in 0 ..< c {
            let p = Particle(body.location, random(0.03.m, 0.05.m))
            p.color = float4(1, 1, 0, 1)
            let angle = random(-Float.pi, Float.pi)
            let mag = random(2, 6) * 1.m
            p.body.velocity = float2(cos(angle), sin(angle)) * mag
            Map.current.append(p)
        }
    }
    
    override func fire() {
        weapon.direction = normalize(Player.player.body.location - body.location)
        if weapon.canFire {
            weapon.fire()
            play("shoot1", 1.2)
        }
    }
    
}


class Coordinator {
    var waves: [Battalion]
    var count: Int
    
    static var wave: Int = 0
    
    init(_ amount: Int) {
        count = amount
        Coordinator.wave = amount
        waves = []
        next()
    }
    
    func next() {
        waves.append(Legion(float2(Map.current.size.x / 2, -12.m), 5))
        count -= 1
        Coordinator.wave -= 1
    }
    
    func update() {
        if let front = waves.first {
            front.update()
            if front.health <= 0 {
                waves.removeFirst()
                if count > 0 {
                    next()
                }
            }
        }
    }
    
}

protocol Battalion {
    var health: Int { get }
    
    func update()
}

class Legion: Battalion {
    
    var rows: [Row]
    
    init(_ location: float2, _ amount: Int) {
        rows = []
        for i in 0 ..< amount {
            rows.append(Row(float2(location.x, location.y - Float(i) * 1.75.m), 4 + Int(arc4random() % 4)))
        }
    }
    
    func update() {
        rows.forEach{
            $0.update()
        }
        rows = rows.filter{ $0.soldiers.count > 0 }
        rows.first?.fire()
    }
    
    var health: Int {
        var sum = 0
        rows.forEach{ sum += $0.health }
        return sum
    }
    
}

class Row: Battalion {
    
    var soldiers: [Soldier]
    var rate: Float = 0.3
    var counter: Float = 0
    var amount: Int
    
    init(_ location: float2, _ amount: Int) {
        self.amount = amount
        soldiers = []
        let start = location + float2(-Float(amount) / 2 * 1.5.m, 0)
        for i in 0 ..< amount {
            let loc = start + float2(Float(i) * 1.5.m, 0)
            var soldier: Soldier
            if i == 0 && arc4random() % 5 == 0 {
                soldier = Captain(loc)
            }else if arc4random() % 7 == 0 {
                soldier = Sniper(loc)
            }else{
                soldier = Soldier(loc)
            }
            soldiers.append(soldier)
            Map.current.append(soldier)
        }
    }
    
    func update() {
        soldiers = soldiers.filter{ $0.alive }
        soldiers.forEach{
            if let captain = $0 as? Captain {
                captain.rage = 1 - Float(health - 1) / Float(amount)
            }
        }
    }
    
    func fire() {
        if arc4random() % 100 >= 85 {
            let index = Int(arc4random()) % soldiers.count
            soldiers[index].fire()
        }
    }
    
    var health: Int {
        var sum = 0
        soldiers.forEach{ sum += $0.alive ? 1 : 0 }
        return sum
    }
    
}















