//
//  Enemies.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Created {
    init(_ location: float2)
}

class Soldier: Entity, Created {
    
    var color: float4
    var weapon: Weapon?
    var health: Health
    
    var terminator: ActorTerminationDelegate?
    var animator: SoldierAnimator?
    var drop: Drop?
    
    required convenience init(_ location: float2) {
        let shield = Shield(Float(15), Float(1.5), Float(40))
        let health = Health(5, shield)
        self.init(location, health, float4(1))
        animator = MarchAnimator(self, 0.1, 0.075.m)
        let bullet = BulletInfo(10, 8.m, 2.5, float2(0.5.m, 0.14.m), float4(1, 0.25, 0, 1))
        weapon = Weapon(transform, float2(0, 1), bullet, "player")
        weapon?.offset = float2(-0.275.m, -0.5.m)
    }
    
    init(_ location: float2, _ health: Health, _ color: float4) {
        self.color = color
        let rect = Rect(location, float2(56, 106) * 1.2)
        
        self.health = health
        
        super.init(rect, Substance.getStandard(100))
        
        display.texture = GLTexture("soldier_walk").id
        display.color = color
        
        body.mask = 0b100
        body.object = self
        body.noncolliding = true
        
        terminator = SoldierTerminator(self)
    }
    
    func damage(amount: Int) {
        health.damage(Float(amount))
        let a = Audio("hit2")
        a.volume = 0.5
        a.start()
    }
    
    override func update() {
        super.update()
        weapon?.update()
        animator?.animate()
        if health.percent <= 0 {
            alive = false
            terminator?.terminate()
        }
        if let shield = health.shield {
            if shield.broke {
                shield.explode(transform)
            }
            shield.update()
            display.color = shield.apply(color)
        }
        fire()
    }
    
    func fire() {
        if arc4random() % 100 >= 98 {
            if ActorUtility.hasLineOfSight(self) {
                if let weapon = weapon {
                    if weapon.canFire {
                        weapon.fire()
                        play("shoot3")
                    }
                }
            }
        }
    }
    
}

class Scout: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(5, nil), float4(0.5, 0.5, 0.5, 1))
        animator = MarchAnimator(self, 0.075, 0.125.m)
        let bullet = BulletInfo(10, 8.m, 0.25, float2(0.5.m, 0.14.m), float4(1, 0.75, 0, 1))
        weapon = Weapon(transform, float2(0, 1), bullet, "player")
        weapon?.offset = float2(-0.275.m, -0.5.m)
    }
    
}

class Banker: Soldier {
    
    required init(_ location: float2) {
        let shield = Shield(Float(30), Float(0.25), Float(80))
        super.init(location, Health(30, shield), float4(1, 1, 0.25, 1))
        animator = MarchAnimator(self,  0.1, 0.075.m)
        drop = CoinDrop(Int(arc4random() % 3) + 3, 1)
    }
    
    override func update() {
        super.update()
        if health.percent <= 0.5 {
            if random(0, 1) <= 0.25 {
                animator = MarchAnimator(self, 0.025, -0.1.m)
            }
        }
        if transform.location.y < -Camera.size.y * 2 {
            alive = false
        }
    }
    
}

class Captain: Soldier {
    
    var rushed: Bool
    
    required init(_ location: float2) {
        rushed = false
        super.init(location, Health(30, Shield(Float(30), Float(2.0), Float(30))), float4(1, 0.5, 0.5, 1))
        animator = MarchAnimator(self, 0.1, 0.075.m)
        let bullet = BulletInfo(20, 6.m, 1.0, float2(0.5.m, 0.14.m) * 1.2, float4(1, 0, 0, 1))
        weapon = Weapon(transform, float2(0, 1), bullet, "player")
        weapon?.offset = float2(-0.275.m, -0.5.m)
    }
    
    override func update() {
        super.update()
        
        if transform.location.y >= -Camera.size.y * 0.75 {
            if !rushed {
                if random(0, 1) <= 0.1 {
                    rush(2.m)
                    rushed = true
                }
            }
        }
        
    }
    
    func rush(_ radius: Float) {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier, let marcher = soldier.animator as? MarchAnimator {
                marcher.sprint = 1.5
            }
        }
        let ex = Explosion(transform.location, radius)
        ex.color = float4(1, 0, 0, 1)
        Map.current.append(ex)
    }
    
}

class Healer: Soldier {
    
    var timer: Timer!
    
    required init(_ location: float2) {
        super.init(location, Health(15, Shield(Float(15), Float(1.0), Float(50))), float4(0.25, 1, 0.25, 1))
        animator = MarchAnimator(self,  0.1, 0.075.m)
        timer = Timer(2) { [unowned self] in
            if random(0, 1) <= 0.1 {
                self.heal(2.m)
            }
        }
    }
    
    override func update() {
        super.update()
        timer.update(Time.delta)
    }
  
    func heal(_ radius: Float) {
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(radius)))
        for actor in actors {
            if let soldier = actor as? Soldier {
                soldier.health.shield?.points.increase(30)
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
        animator = MarchAnimator(self, 0.1, 0.075.m)
        let bullet = BulletInfo(30, 6.m, 1.5, float2(0.5.m, 0.14.m) * 1.4, float4(1, 0, 1, 1))
        weapon = Weapon(transform, float2(0, 1), bullet, "player")
        weapon?.offset = float2(-0.275.m, -0.5.m)
    }
    
}

class Sniper: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(20), Float(0.5), Float(60))), float4(1, 0.5, 1, 1))
        animator = MarchAnimator(self, 0.1, 0.075.m)
        let bullet = BulletInfo(50, 10.m, 2.0, float2(0.6.m, 0.1.m), float4(0, 1, 1, 1))
        weapon = Weapon(transform, float2(0, 1), bullet, "player")
        weapon?.offset = float2(-0.275.m, -0.5.m)
    }
    
}

protocol SoldierAnimator {
    func animate()
}

class MarchAnimator: SoldierAnimator {
    
    unowned let soldier: Soldier
    
    var rate: Float
    var speed: Float
    
    var counter: Float
    var sprint: Float
    
    init(_ soldier: Soldier, _ rate: Float, _ speed: Float) {
        self.soldier = soldier
        self.rate = rate
        self.speed = speed
        counter = 0
        sprint = 0
    }
    
    func animate() {
        if ActorUtility.spaceInFront(soldier, float2(0.5.m, 0)) {
            counter += Time.delta
            
            var final_rate = rate
            
            if sprint > 0 {
                sprint -= Time.delta
                final_rate = 0.05
            }
            
            if counter >= final_rate {
                counter = 0
                soldier.body.location.y += speed
                soldier.display.scheme.schemes[0].layout.flip(vector: float2(-1, 1))
                if soldier.body.location.y > -Camera.size.y {
                    play("march1")
                }
            }
        }
    }
    
}

protocol ActorTerminationDelegate {
    func terminate()
}

protocol Drop {
    func release(_ location: float2)
}

class CoinDrop: Drop {
    
    let amount: Int
    let chance: Float
    
    init(_ amount: Int, _ chance: Float) {
        self.amount = amount
        self.chance = chance
    }
    
    func release(_ location: float2) {
        guard random(0, 1) <= chance else { return }
        for _ in 0 ..< amount {
            let coin = Coin(location, 1)
            let angle = random(-Float.pi, Float.pi)
            let mag = random(2, 4) * 1.m
            coin.body.velocity = float2(cos(angle), sin(angle)) * mag
            Map.current.append(coin)
        }
    }
    
}

class SoldierTerminator: ActorTerminationDelegate {
    
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func terminate() {
        let a = Audio("explosion1")
        a.volume = 1
        a.start()
        soldier.drop?.release(soldier.transform.location)
    }
    
}

class ActorUtility {
    
    static func hasLineOfSight(_ actor: Entity) -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(float2(actor.transform.location.x, actor.transform.location.y + Camera.size.y / 2 + actor.body.shape.getBounds().bounds.y), float2(0.5.m, Camera.size.y)))
        for a in actors {
            if a is Soldier {
                return false
            }
        }
        return true
    }
    
    static func spaceInFront(_ actor: Entity, _ bounds: float2) -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(float2(actor.transform.location.x, actor.transform.location.y + actor.body.shape.getBounds().bounds.y / 2), bounds))
        for a in actors {
            if a !== actor {
                if a is Soldier {
                    return false
                }
            }
        }
        return true
    }
    
}

class Coordinator {
    var waves: [Battalion]
    var count: Int
    
    static var wave: Int = 0
    
    let legion_gen: LegionGenerator
    var difficulty: Difficulty
    
    init(_ mode: Int) {
        difficulty = Difficulty(GameData.info.level)
        legion_gen = LegionGenerator(difficulty)
        count = mode == 0 ? difficulty.waves : 100
        Coordinator.wave = 0
        waves = []
    }
    
    func setWave(_ wave: Int) {
        Coordinator.wave = wave
        difficulty.wave = wave
        count = 100 - wave
    }
    
    func next() {
        count -= 1
        Coordinator.wave += 1
        difficulty.wave = Coordinator.wave
        waves.append(legion_gen.create())
    }
    
    var empty: Bool {
        return waves.first?.health ?? 0 <= 0
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
        }else{
            next()
        }
    }
    
}

protocol Battalion {
    var health: Int { get }
    
    func update()
}

class Legion: Battalion {
    
    var rows: [Row]
    
    init(_ rows: [Row]) {
        self.rows = rows
    }
    
    func update() {
        rows.forEach{
            $0.update()
        }
        rows = rows.filter{ $0.soldiers.count > 0 }
    }
    
    var health: Int {
        var sum = 0
        rows.forEach{ sum += $0.health }
        return sum
    }
    
}

class Row: Battalion {
    
    var soldiers: [Soldier]
    var amount: Int
    
    init(_ soldiers: [Soldier]) {
        self.soldiers = soldiers
        amount = soldiers.count
    }
    
    func update() {
        soldiers = soldiers.filter{ $0.alive }
    }
    
    var health: Int {
        var sum = 0
        soldiers.forEach{ sum += $0.alive ? 1 : 0 }
        return sum
    }
    
}















