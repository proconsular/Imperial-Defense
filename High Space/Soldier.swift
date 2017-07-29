//
//  Soldier.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Soldier: Entity, Damagable {
    
    var color: float4
    var weapon: Weapon?
    var health: Health
    
    var terminator: ActorTerminationDelegate?
    var drop: Drop?
    
    var behavior: SoldierBehavior
    
    var animator: Animator!
    
    var anim: Float = 0
    
    var absorb: AbsorbEffect?
    var canSprint: Bool = false
    var sprintCounter: Float = 0
    var sprinter: Bool = false
    var sprintCooldown: Float = 0
    
    var weapon_power: Display
    
    var reflective: Bool = false
    
    init(_ location: float2, _ health: Health, _ color: float4) {
        self.color = color
        let rect = Rect(location, float2(125))
        let bodyhull = Rect(location, float2(65, 85))
        bodyhull.transform = rect.transform
        self.health = health
        
        behavior = SoldierBehavior()
        
        weapon_power = Display(Circle(Transform(float2()), 0.05.m), GLTexture())
        weapon_power.color = float4(1, 0, 0, 1)
        
        super.init(rect, bodyhull, Substance.getStandard(100))
        
        display.texture = GLTexture("Soldier4").id
        let brightness: Float = 0.5
        display.color = float4(brightness, brightness, brightness, 1)
        
        body.tag = "enemy"
        
        body.mask = 0b100
        body.object = self
        body.noncolliding = true
        
        terminator = SoldierTerminator(self)
        
        animator = BaseMarchAnimator(body, 0.04, 26.m)
        animator.apply(display)
        
        if let shield = health.shield {
            display.technique = ShieldTechnique(shield, transform, float4(0.1, 0.7, 1, 1), rect.bounds.y)
            shield.delegate = EnemyShieldAudio()
            absorb = AbsorbEffect(3, 0.075, 0.75.m, 4, float4(0.1, 0.7, 1, 1), 0.25.m, body)
        }
        
    }
    
    func sprint() {
        if canSprint {
            animator.set(1)
            sprintCounter = 1.5
            sprintCooldown = 5
        }
    }
    
    func damage(_ amount: Float) {
        if transform.location.y < -GameScreen.size.y + 0.5.m { return }
        if let shield = health.shield, shield.percent > 0 {
            let hit = Audio("enemy-shield-hit")
            hit.volume = 1
            hit.start()
        }else{
            let hit = Audio("enemy-health-hit")
            hit.volume = 1
            hit.start()
        }
        health.damage(amount)
    }
    
    override func update() {
        super.update()
        
        sprintCooldown -= Time.delta
        
        if sprintCounter >= 0 && !sprinter {
            sprintCounter -= Time.delta
            if sprintCounter <= 0 {
                animator.set(0)
            }
        }
        
        weapon?.update()
        behavior.update()
        absorb?.update()
        
        if let shield = health.shield {
            if shield.percent <= 0 {
                if random(0, 1) < 0.2 {
                    makeSparks()
                }
            }
        }
        body.velocity.y *= 0.95
        terminate()
        updateShield()
    }
    
    override func render() {
        super.render()
//        if let gun = weapon {
//            weapon_power.color = float4(0.65, 0.5, 0.5, 1) * clamp(gun.firer.charge * 0.5, min: 0, max: 0.5)
//            weapon_power.transform.location = gun.firepoint
//            let circle = weapon_power.scheme.schemes[0].hull as! Circle
//            circle.setRadius(clamp(0.1.m * gun.firer.charge, min: 1, max: 0.05.m))
//            weapon_power.refresh()
//            weapon_power.render()
//        }
    }
    
    func makeSparks() {
        let width: Float = 75
        let height: Float = 100
        let spark = Particle(transform.location + float2(random(-width / 2, width / 2), random(-height / 2, height / 2)), random(3, 6))
        spark.color = float4(0, random(0.5, 0.75), random(0.75, 1), 1)
        let velo: Float = 50
        spark.body.velocity = float2(random(-velo, velo), random(-velo, velo) - velo / 2)
        Map.current.append(spark)
    }
    
    func terminate() {
        if health.percent <= 0 {
            alive = false
            terminator?.terminate()
            let count = Int(random(5, 10))
            for _ in 0 ..< count {
                makeParts()
            }
        }
    }
    
    func makeParts() {
        let width: Float = 75
        let height: Float = 100
        let spark = Particle(transform.location + float2(random(-width / 2, width / 2), random(-height / 2, height / 2)), random(4, 9))
        let col = random(0.5, 0.75)
        spark.color = float4(col, col, col, 1)
        let velo: Float = 400
        spark.body.relativeGravity = 1
        spark.rate = 2.5
        spark.body.velocity = float2(random(-velo, velo) / 2, random(-velo, -velo / 2))
        Map.current.append(spark)
    }
    
    func updateShield() {
        if let shield = health.shield {
            if shield.broke {
                shield.explode(transform)
            }
            let a = shield.percent
            shield.update()
            let b = shield.percent
            if a < b {
                absorb?.generate()
            }
        }
    }
    
}









