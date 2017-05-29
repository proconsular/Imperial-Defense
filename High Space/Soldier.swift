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
    
    init(_ location: float2, _ health: Health, _ color: float4) {
        self.color = color
        let rect = Rect(location, float2(135))
        let bodyhull = Rect(location, float2(75, 100))
        bodyhull.transform = rect.transform
        self.health = health
        
        behavior = SoldierBehavior()
        
        super.init(rect, bodyhull, Substance.getStandard(100))
        
        display.texture = GLTexture("soldier_walk").id
        display.color = color
        
        body.tag = "enemy"
        
        body.mask = 0b100
        body.object = self
        body.noncolliding = true
        
        terminator = SoldierTerminator(self)
        
        animator = BaseMarchAnimator(body, 0.05, 0.15.m)
        animator.apply(display)
        
        if let shield = health.shield {
            display.technique = ShieldTechnique(shield, transform, float4(0.1, 0.7, 1, 1), rect.bounds.y)
            shield.delegate = EnemyShieldAudio()
            absorb = AbsorbEffect(3, 0.075, 0.75.m, 4, float4(0.1, 0.7, 1, 1), 0.25.m, transform)
        }
    }
    
    func damage(_ amount: Float) {
        if transform.location.y < -GameScreen.size.y + 0.5.m { return }
        health.damage(amount)
    }
    
    override func update() {
        super.update()
        
        weapon?.update()
        behavior.update()
        absorb?.update()
        
        if random(0, 1) < 0.0001 {
            behavior.push(TemporaryBehavior(MarchBehavior(self, BaseMarchAnimator(body, 0.025, 0.175.m)), 4))
        }
        
        if let shield = health.shield {
            if shield.percent <= 0 {
                if random(0, 1) < 0.2 {
                    makeSparks()
                }
            }
        }
        
        terminate()
        updateShield()
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









