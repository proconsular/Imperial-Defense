//
//  Enemies.swift
//  Defender
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol Created {
    init(_ location: float2)
}

class Soldier: Actor, Created {
    
    var weapon: Weapon!
    var rate: Float = 0.3
    var counter: Float = 0
    var health: Int = 25
    var weight: Int = 1
    
    var armor: Int = 0
    var shield: Int = 0
    
    var hit_opacity: Float = 0
    
    var color: float4
    
    var armor_image: Display!
    
    required convenience init(_ location: float2) {
        self.init(location, float4(1))
    }
    
    init(_ location: float2, _ color: float4) {
        self.color = color
        let rect = Rect(location, float2(56, 106) * 1.1)
        armor_image = Display(Rect(Transform(location), float2(78, 106) * 1.1), GLTexture("armor"))
        super.init(rect, Substance.getStandard(100))
        display.texture = GLTexture("soldier_walk").id
        weapon = Weapon(transform, float2(0, 1), BulletInfo(5, 10.m, 1, float2(0.4.m, 0.08.m), float4(1, 0, 0, 1)), "player")
        weapon.offset = float2(-0.275.m, -0.5.m)
        body.mask = 0b100
        body.object = self
        body.noncolliding = true
    }
    
    func damage(amount: Int) {
        let hasArmor = armor > 0
        health -= max(amount - armor, 0)
        armor -= amount
        if armor < 0 {
            armor = 0
        }
        if hasArmor && armor <= 0 {
            play("break1", 0.6)
        }
        hit_opacity += Float(amount)
        let a = Audio("hit2")
        a.volume = 0.5
        a.start()
    }
    
    override func update() {
        super.update()
        weapon.update()
        move()
        if health <= 0 {
            alive = false
            Data.info.points += weight
            death()
        }
        display.color = color - float4(0, hit_opacity, hit_opacity, 0)
        display.visual.refresh()
        hit_opacity += -4.5 * Time.time
        hit_opacity = clamp(hit_opacity, min: 0, max: 1)
        if !inView(0.95) && spaceInFront() {
            body.location.y += 0.005.m
        }
    }
    
    func death() {
        let a = Audio("explosion1")
        a.volume = 1
        a.start()
        let c = arc4random() % 5 + 5
        for _ in 0 ..< c {
            let p = Particle(body.location, random(0.03.m, 0.04.m))
            p.rate = 2.5
            let angle = random(-Float.pi, Float.pi)
            let mag = random(2, 6) * 1.m
            p.body.velocity = float2(cos(angle), sin(angle)) * mag
            Map.current.append(p)
        }
        score()
    }
    
    func score() {
        Map.current.append(TextParticle(transform.location, "+\(weight)", 64))
    }
    
    func move() {
        counter += Time.time
        if counter >= rate * 0.75 {
            counter = 0
            body.location.y += 0.075.m
            display.scheme.layout.flip(vector: float2(-1, 0))
            display.visual.refresh()
            let a = Audio("march1")
            a.volume = 0.3
            a.start()
        }
    }
    
    func fire() {
        if arc4random() % 100 >= 98 {
            if hasLineOfSight() {
                if weapon.canFire {
                    weapon.fire()
                    play("shoot3")
                }
            }
        }
    }
    
    func hasLineOfSight() -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(float2(transform.location.x, transform.location.y + Camera.size.y / 2 + body.shape.getBounds().bounds.y), float2(0.5.m, Camera.size.y)))
        for a in actors {
            if a is Soldier {
                return false
            }
        }
        return true
    }
    
    func spaceInFront() -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(float2(transform.location.x, transform.location.y + body.shape.getBounds().bounds.y), float2(0.5.m, 1.m)))
        for a in actors {
            if a is Soldier {
                return false
            }
        }
        return true
    }
    
    func inView(_ percent: Float = 0.9) -> Bool {
        return Camera.contains(body.shape.getBounds()) && transform.location.y > -Camera.size.y * percent
    }
    
    override func render() {
        super.render()
        if armor > 0 {
            armor_image.transform.location = transform.location
            armor_image.render()
        }
    }
    
}

class Captain: Soldier {
    
    var rage: Float
    var direction: Int = 1
    var width: Float = 10.m
    
    required init(_ location: float2) {
        rage = 0
        super.init(location, float4(0, 0, 1, 1))
        weapon.bullet_data.rate = 0.2
        health = 70
        weight = 10
        display.texture = GLTexture("adv_soldier").id
    }
    
    override func update() {
        super.update()
        if rage > 0.3 && hasLineOfSight() {
            rate = clamp(0.5 - 0.4 * (1 - rage), min: 0.2, max: 1)
        }
        display.color = float4(0.5 + 0.7 * rage, 0, 0.5 * (1 - rage), 1)
        display.visual.refresh()
        if rage >= 0.3 {
            if weapon.canFire && inView() && hasLineOfSight() {
                weapon.fire()
                play("shoot3")
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
        score()
    }
    
    override func fire() {
       
    }
    
}

class Sniper: Soldier {
    
    required init(_ location: float2) {
        super.init(location, float4(1, 1, 0, 1))
        weight = 5
        weapon.bullet_data = BulletInfo(20, 20.m, 1, float2(0.6.m, 0.04.m), float4(1, 1, 0, 1))
        display.texture = GLTexture("adv_soldier").id
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
        score()
    }
    
    override func fire() {
        weapon.direction = normalize(Player.player.body.location - body.location)
        if weapon.canFire && inView() {
            weapon.fire()
            play("shoot1", 1.2)
        }
    }
    
}

class Bomber: Soldier {
    
    required init(_ location: float2) {
        super.init(location, float4(0, 1, 0, 1))
        health = 60
        weight = 10
        var data = BulletInfo(5, 5.m, 2, float2(0.5.m), float4(0, 0, 0, 1))
        data.collide = {
            let actors = Map.current.getActors(rect: FixedRect($0.body.location, float2(2.m)))
            for a in actors {
                if let s = a as? Player {
                    s.hit(amount: 10)
                }
                if let bar = a as? Wall {
                    bar.health -= 10
                }
            }
            Map.current.append(Explosion($0.body.location, 2.m))
            let a = Audio("explosion1")
            a.volume = 1
            a.pitch = 0.6
            a.start()
        }
        weapon.bullet_data = data
        display.texture = GLTexture("adv_soldier").id
    }
    
    override func fire() {
        if inView() {
            super.fire()
        }
    }
    
}

class LaserSoldier: Soldier {
    
    var laser: LaserWeapon
    var firing = false
    var wait: Float = 0
    
    required init(_ location: float2) {
        let lase = Laser(location, 0.1.m, -1)
        laser = LaserWeapon(lase) {
            if let player = $0 as? Player {
                player.hit(amount: 10)
            }
            if let wall = $0 as? Wall {
                wall.health -= 5
            }
        }
        laser.limit = 2
        laser.rate = 0.2
        laser.power = 0
        super.init(location, float4(1, 0.8, 1, 1))
        weight = 30
        health = 60
        display.texture = GLTexture("laser_soldier").id
    }
    
    override func update() {
        if firing {
            laser.fire()
        }
        laser.laser.transform.location = transform.location + float2(0, 0.75.m) + float2(-0.25.m, -0.5.m)
        laser.update()
        
        let amount = laser.power / laser.limit
        
        color = float4(1, 1 - 1.2 * amount * amount * amount, 1, 1)
        
        super.update()
        
        if laser.power <= 0 {
            firing = false
        }
    }
    
    override func fire() {
        if hasLineOfSight() && inView() {
            //wait += Time.time
            //if wait >= 2 {
                firing = true
            //}
        }
    }
    
    override func render() {
        super.render()
        laser.render()
    }
    
}


class Coordinator {
    var waves: [Battalion]
    var count: Int
    
    static var wave: Int = 0
    
    let legion_gen: LegionGenerator
    var difficulty: Difficulty
    
    init() {
        difficulty = Difficulty(Data.info.level)
        legion_gen = LegionGenerator(difficulty)
        count = difficulty.waves
        Coordinator.wave = 0
        waves = []
        next()
    }
    
    func next() {
        count -= 1
        Coordinator.wave += 1
        difficulty.wave += 1
        waves.append(legion_gen.create())
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
    
    init(_ rows: [Row]) {
        self.rows = rows
        
//        for i in 0 ..< clamp(amount, min: 0, max: 10) {
//            let local = Float(i) * 0.025 + Float(wave) * 0.05
//            let level = local + Float(Data.info.level) * 0.01
//            //rows.append(Row(float2(location.x, location.y - Float(i) * 1.25.m), clamp(level, min: 0, max: 1)))
//        }
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
        //create(location, level)
    }
    
    func create(_ location: float2, _ level: Float) {
        let start = location + float2(-Float(amount) / 2 * 1.m, 0)
        for i in 0 ..< amount {
            let loc = start + float2(Float(i) * 1.m, 0)
            let soldier = selectType(loc, level, i)
            
            soldiers.append(soldier)
            Map.current.append(soldier)
        }
    }
    
    func selectType(_ loc: float2, _ level: Float, _ i: Int) -> Soldier {
        var soldier: Soldier
        if computeChance(30, level) && Data.info.level >= 10 {
            soldier = Captain(loc)
        }else if computeChance(30, level) && Data.info.level >= 5 {
            soldier = Sniper(loc)
        }else if computeChance(30, level) && Data.info.level >= 15 {
            soldier = Bomber(loc)
        }else if computeChance(30, level) && Data.info.level >= 20 {
            soldier = LaserSoldier(loc)
        }else{
            let ra = random(0.8, 1)
            soldier = Soldier(loc, float4(ra, ra, ra, 1))
        }
        
        if computeChance(20, level) && Data.info.level >= 7 {
            soldier.armor = 40
        }
        
        if computeChance(40, level) && Data.info.level >= 12 {
            soldier.armor = 80
            soldier.armor_image.color = float4(0, 0, 0.5, 1)
        }
        
        if computeChance(40, level) && Data.info.level >= 25 {
            soldier.armor = 200
            soldier.armor_image.color = float4(0.5, 0, 0, 1)
        }
        
        return soldier
    }
    
    func computeChance(_ max: Float, _ level: Float) -> Bool {
        let gradient = UInt32(max * (1 - level))
        return (gradient > 0 ? Int(arc4random() % gradient) : 0) == 0
    }
    
    func update() {
        soldiers = soldiers.filter{ $0.alive }
        soldiers.forEach{
            if let captain = $0 as? Captain {
                captain.rage = 1 - Float(health - 1) / Float(amount)
            }
            fire()
        }
    }
    
    func fire() {
            let index = Int(arc4random()) % soldiers.count
            soldiers[index].fire()
    }
    
    var health: Int {
        var sum = 0
        soldiers.forEach{ sum += $0.alive ? 1 : 0 }
        return sum
    }
    
}















