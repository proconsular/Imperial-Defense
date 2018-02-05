//
//  Player.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/22/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Player: Entity, Damagable {
    var reflective: Bool = false
    
    static weak var player: Player!
    
    var dead: Bool = false
    var drag: Float = 0.7
    var firing = false
    
    var health: Health
    var weapon: PlayerWeapon!
    
    var terminator: ActorTerminationDelegate?
    let animator: TextureAnimator
    
    var animation: PlayerAnimation!
    var event: PlayerEvent?
    
    var trail: TrailEffect!
    
    init(_ location: float2, _ health: Health, _ firer: Firer, _ power: Power) {
        self.health = health
        
        let transform = Transform(location)
        weapon = PlayerWeapon(transform, float2(0, -1), power, firer)
        weapon.offset = float2(0, -0.25.m)
        
        animator = TextureAnimator(GLTexture("Player").id, SheetLayout(0, 8, 4))
        animator.append(SheetAnimator(0.1, [], SheetAnimation(0, 5, 8, 1)))
        animator.append(SheetAnimator(0.25, [], SheetAnimation(8, 4, 8, 1)))
        
        let image = Rect(transform, float2(48, 48) * 4)
        let bodyhall = Rect(transform, float2(100, 100))
        
        super.init(image, bodyhall, Substance(PhysicalMaterial(.wood), Mass(10, 0), Friction(.iron)))
        
        Player.player = self
        
        body.object = self
        body.tag = "player"
        body.mask = 0b10
        
        material.set(100, GLTexture("Player").id, animator.coordinates)
        
        terminator = ExplosionTerminator(self, 17.5.m, float4(1))
        
        createShieldMaterial()
        //health.shield!.effect = ShieldAbsorbEffect(transform, health.shield!, AbsorbEffect(3, 0.025, 1.25.m, 7, upgrader.shieldColor, 0.75.m, body))
        
        health.shield!.delegates.append(PlayerShieldEffect(transform))
        
        trail = TrailEffect(self, 0.1, 4 + (1 - upgrader.shieldpower.range.percent) * 4)
        
        weapon.delegate = PlayerWeaponSound(self)
        animation = PlayerWalk(body, animator)
        event = DeathEvent(self)
        
        reaction = DamageReaction(self)
    }
    
    func createShieldMaterial() {
        let shield_material = ShieldMaterial(health.shield!, transform, upgrader.shieldColor, handle.hull.getBounds().bounds.y)
        shield_material["texture"] = material["texture"]
        handle.materials.append(shield_material)
    }
    
    func damage(_ amount: Float) {
        let augment = amount * (Float(GameData.info.challenge) * 0.25)
        health.damage(amount + augment)
        Audio.play("player_hit", 0.2)
    }
    
    override func update() {
        super.update()
        
        if upgrader.shieldpower.range.amount >= 1 {
            trail.update()
        }
        
        health.shield?.update()
        
        weapon.update()
        
        body.velocity.x *= drag * (firing ? 0.8 : 1)
        firing = false
        
        if let e = event {
            if e.isActive() {
                e.trigger()
                event = nil
            }
        }
        
        animation.update()
        
        material.coordinates = animator.coordinates
    }
    
}

class PlayerShieldEffect: ShieldDelegate {
    unowned let transform: Transform
    
    init(_ transform: Transform) {
        self.transform = transform
    }
    
    func recover(_ percent: Float) {
        if percent < 0.9 {
            Map.current.append(Halo(transform.location, 3.25.m))
        }
    }
    
    func damage() {
        
    }
    
}











