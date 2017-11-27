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
    var canSprint: Bool = false
    var sprintCounter: Float = 0
    var sprinter: Bool = false
    var sprintCooldown: Float = 0
    
    var reflective: Bool = false
    
    var trail: TrailEffect!
    
    var immune: Bool = false
    
    var shield_material: ShieldMaterial?
    
    var immune_flicker: Float = 0
    var immune_timer: Float = 0
    
    init(_ location: float2, _ health: Health, _ color: float4, _ texture: String = "Soldier4") {
        self.color = color
        let rect = Rect(location, float2(125))
        let bodyhull = Rect(location, float2(65, 85))
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
            shield.delegate = EnemyShieldAudio()
            absorb = AbsorbEffect(3, 0.075, 0.75.m, 4, float4(0.1, 0.7, 1, 1), 0.25.m, body)
        }
        
        trail = TrailEffect(self, 0.15, 1.5)
        
        reaction = DamageReaction(self)
    }
    
    func sprint() {
        if canSprint {
            animator.set(1)
            sprintCounter = 1.5
            sprintCooldown = 5
        }
    }
    
    func stop(_ time: Float, _ action: @escaping () -> ()) {
        let animator = BaseMarchAnimator(body, 10, 0.0.m)
        animator.set(sprinter ? 1 : 0)
        behavior.push(TemporaryBehavior(MarchBehavior(self, animator), time))
        behavior.push(TemporaryBehavior(MarchBehavior(self, animator), 0.1, action))
    }
    
    func setImmunity(_ immune: Bool, _ time: Float = 0) {
        self.immune = immune
        self.immune_timer = time
        if immune {
            if let shield = health.shield {
                shield.points.amount = shield.points.limit
            }
        }
        if let mat = shield_material {
            mat.overlay = immune
            mat.overlay_color = float4(1, 1, 1, 1)
        }
    }
    
    func damage(_ amount: Float) {
        if immune { return }
        if transform.location.y < -GameScreen.size.y + 0.5.m { return }
        if let shield = health.shield, shield.percent > 0 {
            let hit = Audio("enemy-shield-hit")
            hit.volume = sound_volume * 10
            hit.start()
        }else{
            let hit = Audio("enemy-health-hit")
            hit.volume = sound_volume * 4
            hit.start()
        }
        health.damage(amount)
    }
    
    override func update() {
        super.update()
        
        sprintCooldown -= Time.delta
        if sprintCounter >= 0 && !sprinter {
            sprintCounter -= Time.delta
            
            trail.update()
            
            if sprintCounter <= 0 {
                animator.set(0)
            }
        }
        
        if immune {
            if let mat = shield_material {
                immune_flicker += Time.delta
                if immune_flicker >= 0.05 {
                    immune_flicker = 0
                    mat.overlay_color = mat.overlay_color.w == 1 ? float4(0.5) : float4(1)
                }
            }
            immune_timer -= Time.delta
            if immune_timer <= 0 {
                setImmunity(false)
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









