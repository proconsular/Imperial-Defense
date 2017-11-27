//
//  BossBehaviors.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BossBehavior: Behavior {
    var alive: Bool = true
    var behaviors: [ActiveBehavior]
    var index: Int
    
    init() {
        behaviors = []
        index = 0
    }
    
    func update() {
        let current = behaviors[index]
        if current.active {
            current.update()
        }
        if !behaviors[index].active {
            replace()
        }
    }
    
    func replace() {
        index = (index + 1) % behaviors.count
        behaviors[index].activate()
    }
    
    func append(_ behavior: ActiveBehavior) {
        behaviors.append(behavior)
    }
    
}

class BossOpeningBehavior: BossBehavior {
    
    override func replace() {
        if index + 1 >= behaviors.count {
            alive = false
        }
        super.replace()
    }
    
}

class ConditionalBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = false
    
    let condition: () -> Bool
    let behavior: Behavior
    
    init(_ behavior: Behavior, _ condition: @escaping () -> Bool) {
        self.behavior = behavior
        self.condition = condition
    }
    
    func activate() {
        if condition() {
            active = true
        }
    }
    
    func update() {
        behavior.update()
        active = condition()
    }
}

protocol ActiveBehavior: Behavior {
    var active: Bool { get }
    func activate()
}

class RandomBehavior: ActiveBehavior {
    var alive: Bool = true
    
    var behaviors: [ActiveBehavior]
    var index: Int
    
    init(_ behaviors: [ActiveBehavior] = []) {
        index = 0
        self.behaviors = behaviors
    }
    
    var active: Bool {
        return behaviors[index].active
    }
    
    func activate() {
        let rand = 1 + Int(random(0, 3) >= 1 ? 0 : 1)
        index = (index + rand) % behaviors.count
        behaviors[index].activate()
    }
    
    func update() {
        behaviors[index].update()
    }
    
}

class TimedBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    var timer, rate: Float
    let behavior: Behavior
    
    init(_ behavior: Behavior, _ rate: Float) {
        self.behavior = behavior
        self.rate = rate
        timer = 0
    }
    
    func activate() {
        active = true
        timer = 0
    }
    
    func update() {
        timer += Time.delta
        if timer >= rate {
            active = false
        }
        behavior.update()
    }
}

class LaserBlastBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    let laser: Laser
    var power: Float
    var angle, direction: Float
    var damage: Float
    
    var timer: Float = 0
    
    let speed: Float
    let length: Float
    
    unowned let shield: ParticleShield
    
    init(_ speed: Float, _ length: Float, _ laser: Laser, _ shield: ParticleShield) {
        self.speed = speed
        self.length = length
        self.laser = laser
        self.shield = shield
        power = length
        angle = Float.pi / 3
        laser.direction = float2(cosf(angle), sin(angle))
        direction = 1
        damage = 10
    }
    
    func activate() {
        active = true
        power = length
        laser.visible = true
        shield.set(CollapseEffect(power))
    }
    
    func update() {
        power -= Time.delta
        if power <= 0 {
            active = false
            laser.visible = false
            return
        }
        move()
        laser.visible = true
        collide()
    }
    
    func move() {
        if let player = Player.player {
            let dl = player.transform.location - Emperor.instance.transform.location
            let nor = normalize(dl)
            let da: Float = (atan2(nor.y, nor.x) - angle) > 0 ? 1 : -1
            angle += speed * da * Time.delta
            laser.direction = vectorize(angle)
        }
    }
    
    func collide() {
        let l = laser.rect
        if let player = Player.player {
            let p = player.body.shape
            let collision = PolygonSolver.solve(Polygon(p.transform, p.getVertices()), l)
            if collision != nil {
                Player.player.damage(damage)
            }
        }
        
    }
}

class ActionBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = false
    
    var action: () -> ()
    
    init(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    func activate() {
        action()
    }
    
    func update() {
        
    }
    
}

class FastLaserBlastBehavior: LaserBlastBehavior {
    
    let start: Float
    
    init(_ start: Float, _ speed: Float, _ length: Float, _ laser: Laser, _ shield: ParticleShield) {
        self.start = start
        super.init(speed, length, laser, shield)
        angle = start
    }
    
    override func activate() {
        angle = start
        laser.direction = vectorize(angle)
        super.activate()
    }
    
}

class PulseLaserBlastBehavior: LaserBlastBehavior {
    
    var charge: Float
    
    init(_ laser: Laser, _ shield: ParticleShield) {
        charge = 0
        super.init(0, 1, laser, shield)
        damage = 100
    }
    
    override func activate() {
        active = true
        power = 1
        laser.visible = true
        shield.set(CollapseEffect(power))
        laser.direction = normalize(Player.player.transform.location - Emperor.instance.transform.location)
        charge = 0
    }
    
    override func update() {
        charge += Time.delta
        if charge >= 0.25 {
            super.update()
        }
    }
    
    override func move() {
        
    }
}

class RestBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var timer: Float = 0
    let length: Float
    
    unowned let shield: ParticleShield
    
    init(_ length: Float, _ shield: ParticleShield) {
        self.length = length
        self.shield = shield
    }
    
    func activate() {
        active = true
        timer = length
        shield.set(CollapseEffect(timer))
    }
    
    func update() {
        timer -= Time.delta
        if timer <= 0 {
            active = false
        }
    }
}

class DarkEnergyBlastBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    let transform: Transform
    var charge: Float = 0
    var mode: Int = 0
    
    var blasts: [DarkBlast]
    
    init(_ transform: Transform) {
        self.transform = transform
        blasts = []
    }
    
    func activate() {
        active = true
        charge = 0
        mode = 0
        
        let blast = DarkBlast(transform.location - float2(2.m, 0), 0.75.m, 10)
        blasts.append(blast)
        let blast1 = DarkBlast(transform.location + float2(2.m, 0), 0.75.m, 10)
        blasts.append(blast1)
    }
    
    func update() {
        charge += Time.delta
        let challenge = FinalBattle.instance.challenge
        if charge >= 1 - 0.5 * challenge && mode < blasts.count {
            charge = 0
            fire(mode)
            mode += 1
        }
        for i in 0 ..< mode {
            let blast = blasts[i]
            if let player = Player.player {
                let dl = player.transform.location - blast.transform.location
                blast.velocity += (normalize(dl) * 16.m) * Time.delta
            }
        }
        for blast in blasts {
            blast.update()
        }
        if charge >= 1.5 - challenge {
            active = false
            blasts.removeAll()
        }
    }
    
    func fire(_ index: Int) {
        let blast = blasts[index]
        if let player = Player.player {
            let dl = player.transform.location - blast.transform.location
            blast.velocity = float2()
            blast.velocity = normalize(dl) * 20.m
        }
        
    }
}

class DarkBlast {
    
    let transform: Transform
    let radius: Float
    var life: Float
    var velocity: float2
    
    var energy: [DarkEnergy]
    
    init(_ location: float2, _ radius: Float, _ life: Float) {
        transform = Transform(location)
        self.radius = radius
        self.life = life
        velocity = float2()
        energy = []
    }
    
    func update() {
        transform.location += velocity * Time.delta
        velocity *= 0.98
        
        energy = energy.filter{ $0.alive }
        
        for _ in 0 ..< 5 {
            spawn()
        }
    }
    
    func spawn() {
        let angle = random(-Float.pi, Float.pi)
        let mag = random(0, radius)
        let loc = float2(cosf(angle), sinf(angle)) * mag
        let energy = DarkEnergy(loc + transform.location, random(6, 9))
        energy.color = float4(0.75, 0.85, 1, 1)
        energy.material.color = float4(0.75, 0.85, 1, 1)
        energy.rate = 1
        self.energy.append(energy)
        Map.current.append(energy)
    }
    
}

class StompBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var timer, rate: Float
    var count, amount: Int
    
    var power, direction: Float
    var magnitude: Float
    
    init(_ rate: Float, _ amount: Int, _ magnitude: Float) {
        self.rate = rate
        self.amount = amount
        self.magnitude = magnitude
        timer = 0
        count = 0
        power = 0
        direction = 1
    }
    
    func activate() {
        active = true
        timer = 0
        count = 0
        power = 0
    }
    
    func update() {
        timer += Time.delta
        if timer >= rate - rate / 2 * FinalBattle.instance.challenge {
            power += 1
            timer = 0
            count += 1
            if count >= amount {
                active = false
                Camera.current.transform.location.x = 0
                return
            }
            let audio = Audio("stomp")
            audio.volume = 1
            audio.start()
        }
        power = clamp(power - Time.delta, min: 0, max: 1)
        shake()
    }
    
    func shake() {
        Camera.current.transform.location.x = power * (magnitude + magnitude * FinalBattle.instance.challenge) * direction
        direction = -direction
    }
}

class SummonLegionBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    unowned let transform: Transform
    
    var timer: Float = 0
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func activate() {
        active = true
//        generator.difficulty.row = 1
//        generator.amount = Int(4 + 4 * FinalBattle.instance.challenge)
        let count = Int(1 + 2 * FinalBattle.instance.challenge)
        let side = arc4random() % 2 == 0 ? Map.current.size.x / 4 : Map.current.size.x * 3 / 4
//        for i in 0 ..< count {
//            let _ = generator.create(float2(side, -Camera.size.y - 2.m) + float2(0, -1.25.m * Float(i)))
//        }
    }
    
    func update() {
        timer += Time.delta
        if timer >= 0.5 {
            timer = 0
            active = false
        }
    }
}

class RubbleFallBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var timer: Float
    var frequency: Float
    
    init() {
        timer = 0
        frequency = 0
    }
    
    func activate() {
        active = true
        timer = 5
    }
    
    func update() {
        timer -= Time.delta
        if timer <= 0 {
            active = false
        }
        
        frequency += Time.delta
        if frequency >= 0.1 {
            frequency = 0
            var location = float2(random(2.m, Camera.size.x - 2.m), random(0, -Camera.size.y + 0.5.m))
            if randomInt(0, 10) < 6 {
                location.y = random(0, -4.m)
                if randomInt(0, 3) < 1 {
                    location.x = Player.player.transform.location.x
                }
            }
            Map.current.append(FallingRubble(location, normalize(float2(0.25, 1))))
        }
    }
}

class ParticleWaveBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var count: Int
    var frequency: Float
    
    var radius: Float = 0
    
    let speed: Float
    let amount: Int
    
    unowned let transform: Transform
    
    init(_ speed: Float, _ amount: Int, _ transform: Transform) {
        self.speed = speed
        self.amount = amount
        self.transform = transform
        count = 0
        frequency = 0
    }
    
    func activate() {
        active = true
        count = amount
        radius = 0
    }
    
    func update() {
        radius += speed * Time.delta
        
        let amount = Int(10 + radius / 5.m + speed / 5.m)
        for i in 0 ..< amount {
            let percent = Float(i) / Float(amount)
            let angle = -Float.pi + 2 * Float.pi * percent + random(0, Float.pi)
            let p = DarkEnergy(transform.location + float2(cosf(angle), sinf(angle)) * radius, random(3, 7))
            p.rate = 1
            p.color = float4(0.75, 0.85, 1, 1)
            p.material.color = float4(0.75, 0.85, 1, 1)
            Map.current.append(p)
        }
        
        if radius >= Camera.size.x {
            radius = 0
            count -= 1
            if count < 0 {
                active = false
            }
        }
    }
    
}


class ParticleBeamBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var count: Float
    
    var radius: Float = 0
    var angle: Float = 0
    
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
        count = 0
    }
    
    func activate() {
        active = true
        count = 5
        radius = 0
        computeAngle()
    }
    
    func computeAngle() {
        let dl = Player.player.transform.location - transform.location
        angle = atan2(dl.y, dl.x)
    }
    
    func update() {
        radius += (12.5.m + random(0, 1.m)) * Time.delta
        
        for _ in 0 ..< 10 {
            let angle = self.angle + random(-0.2, 0.2)
            let p = DarkEnergy(transform.location + float2(cosf(angle), sinf(angle)) * radius, random(5, 8))
            p.rate = 2
            p.color = float4(0.75, 0.85, 1, 1)
            p.material.color = float4(0.75, 0.85, 1, 1)
            Map.current.append(p)
        }
        
        if radius >= Camera.size.x / 2 {
            radius = 0
            count -= 1
            computeAngle()
            if count < 0 {
                active = false
            }
        }
    }
    
}

class ParticleShieldBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    unowned let shield: ParticleShield
    
    var timer: Float = 0
    
    init(_ shield: ParticleShield) {
        self.shield = shield
    }
    
    func activate() {
        shield.set(DefendEffect(3))
        active = true
    }
    
    func update() {
        timer += Time.delta
        if timer >= 3 {
            timer = 0
            active = false
        }
    }
    
}

class ParticleShield {
    
    let transform: Transform
    let radius: Float
    var power: Float
    
    var dilation: Float
    var spawning: Bool
    
    var speed: Float
    var drag: Float
    
    var enabled: Bool
    
    var energy: [Energy]
    
    var effect: ParticleShieldEffect?
    
    init(_ transform: Transform, _ radius: Float) {
        self.transform = transform
        self.radius = radius
        power = 100
        dilation = 1
        spawning = true
        speed = 0.5
        drag = 0.925
        energy = []
        enabled = true
    }
    
    func update() {
        if !enabled { return }
        
        energy = energy.filter{ $0.alive }
        if spawning {
            spawn()
        }
        animate()
        if let e = effect {
            e.update()
            if !e.alive {
                effect = nil
            }
        }
    }
    
    func set(_ effect: ParticleShieldEffect) {
        self.effect = effect
        self.effect!.shield = self
        self.effect!.use()
    }
    
    func animate() {
        for e in energy {
            let dl = e.transform.location - transform.location
            let angle = atan2f(dl.y, dl.x) + 1
            let loc = float2(cosf(angle), sinf(angle)) * radius * dilation
            let da = (transform.location + loc) - e.transform.location
            e.body.velocity += da * speed
            e.body.velocity *= drag
        }
    }
    
    func spawn() {
        let angle = random(-Float.pi, Float.pi)
        let en = Energy(float2(cosf(angle), sinf(angle)) * radius + transform.location, random(3, 5))
        
        let color = float4(0.75, 0.85, 1, 1)
        en.color = color
        en.material.color = color
        en.material.order = 201
        en.rate = 0.25
        
        energy.append(en)
        Map.current.append(en)
    }
    
}

protocol ParticleShieldEffect {
    var alive: Bool { get set }
    var shield: ParticleShield! { get set }
    func use()
    func update()
}

class CollapseEffect: ParticleShieldEffect {
    var alive: Bool = true
    
    let length: Float
    var timer: Float
    
    weak var shield: ParticleShield!
    
    init(_ length: Float) {
        self.length = length
        timer = 0
    }
    
    func use() {
        shield.spawning = false
        shield.drag = 0.95
    }
    
    func update() {
        timer += Time.delta
        if timer >= length {
            shield.drag = 0.925
            shield.dilation = 1
            shield.spawning = true
            alive = false
        }
        shield.drag = clamp(shield.drag - 0.1 * Time.delta, min: 0.9, max: 1)
        shield.dilation = clamp(shield.dilation - 8 * Time.delta, min: 0, max: 1)
        for e in shield.energy {
            let dl = e.transform.location - shield.transform.location
            e.material.color *= dl.length / 2.m
            if dl.length <= 0.1.m {
                e.alive = false
            }
        }
    }
}

class DefendEffect: ParticleShieldEffect {
    var alive: Bool = true
    
    weak var shield: ParticleShield!
    
    let length: Float
    var timer: Float
    
    init(_ length: Float) {
        self.length = length
        timer = 0
    }
    
    func use() {
        shield.drag = 0.85
        shield.speed = 0.5
    }
    
    func update() {
        timer += Time.delta
        if timer >= length {
            shield.drag = 0.925
            shield.speed = 0.5
            alive = false
        }
    }
}

class DeathBehavior: Behavior {
    var alive: Bool = true
    
    var timer: Float = 5
    var blink: Float = 0
    
    unowned let entity: Entity
    
    init(_ entity: Entity) {
        self.entity = entity
    }
    
    func update() {
        entity.body.velocity = float2()
        
        timer -= Time.delta
        if timer <= 0 {
            entity.alive = false
            Map.current.append(PowerInfuser(entity.transform.location))
        }
        
        blink += Time.delta
        if blink >= 0.25 {
            blink = 0
            if entity.material.color == float4(1) {
                entity.material.color = float4(0, 0, 0, 1)
            }else{
                entity.material.color = float4(1)
            }
//            entity.display.refresh()
        }
        
    }
}

class PowerInfuser: Entity {
    
    var timer: Float = 10
    
    init(_ location: float2) {
        let circle = Circle(Transform(location), 0.01.m)
        super.init(circle, circle, Substance.getStandard(0.1))
        body.noncolliding = true
    }
    
    override func update() {
        for _ in 0 ..< 3 {
            spawn()
        }
        timer -= Time.delta
        if timer <= 0 {
            alive = false
        }
    }
    
    func spawn() {
        let p = Particle(transform.location, random(4, 7))
        let range = 30.m
        p.body.velocity = float2(random(-range, range), random(-range, range))
        p.rate = 0.75
        p.drag = float2(0.9)
        let color = float4(0.75, 0.85, 1, 1)
        p.color = color
        p.material.color = color
        p.guider = FollowGuider(p.body, Player.player.transform, 1.5.m)
        Map.current.append(p)
    }
    
}



















