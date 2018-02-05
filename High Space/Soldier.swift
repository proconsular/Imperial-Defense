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
    
    var behavior: SoldierBehavior
    
    var animator: Animator!
    
    var anim: Float = 0
    
    var absorb: AbsorbEffect?
    var trail: TrailEffect!
    
    var sprinter: Bool = false
    var canSprint: Bool = false
    
    var shield_material: ShieldMaterial?
    
    init(_ location: float2, _ health: Health, _ color: float4, _ texture: String = "Soldier4") {
        self.color = color
        let rect = Rect(location, float2(125))
        let bodyhull = Rect(location, float2(50, 85))
        bodyhull.transform = rect.transform
        self.health = health
        
        behavior = SoldierBehavior()
        
        super.init(rect, bodyhull, Substance.getStandard(100))
        
        material["texture"] = GLTexture(texture).id
        let brightness: Float = 0.5
        material["color"] = float4(brightness, brightness, brightness, 1)
        
        body.tag = "enemy"
        
        body.mask = 0b100
        body.object = self
        body.noncolliding = true
        
        terminator = SoldierTerminator(self)
        
        animator = BaseMarchAnimator(body, 0.04 + (Float(GameData.info.challenge) * -0.005), 26.m)
        animator.apply(material)
        
        if let shield = health.shield {
            let sm = ShieldMaterial(shield, transform, float4(0.1, 0.7, 1, 1), rect.bounds.y)
            sm["texture"] = material["texture"]
            handle.materials.append(sm)
            shield_material = sm
            shield.delegates.append(EnemyShieldAudio())
            absorb = AbsorbEffect(3, 0.075, 0.75.m, 4, float4(0.1, 0.7, 1, 1), 0.25.m, body)
        }
        
        trail = TrailEffect(self, 0.15, 1.5)
        
        reaction = DamageReaction(self)
    }
    
    func stop(_ time: Float, _ action: @escaping () -> ()) {
        let animator = BaseMarchAnimator(body, 10, 0.0.m)
        animator.set(sprinter ? 1 : 0)
        behavior.push(TemporaryBehavior(MarchBehavior(self, animator), time))
        behavior.push(TemporaryBehavior(MarchBehavior(self, animator), 0.1, action))
    }
    
    func damage(_ amount: Float) {
        if transform.location.y < -GameScreen.size.y + 0.5.m { return }
        hit()
        health.damage(amount)
    }
    
    func hit() {
        if let mat = shield_material, mat.overlay {
            Audio.play("immune-hit", 0.2)
        }else{
            if let shield = health.shield, shield.percent > 0 {
                Audio.play("enemy-shield-hit", 0.4)
            }else{
                Audio.play("enemy-health-hit", 0.2)
            }
        }
    }
    
    override func update() {
        super.update()
        
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
        body.velocity.x *= 0.9
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
            let ghost = GhostEffect(self, 2)
            ghost.color = float4(0, 0, 0, 1)
            Map.current.append(ghost)
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









