//
//  Soldier.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Soldier: Entity {
    
    var color: float4
    var weapon: Weapon?
    var health: Health
    
    var terminator: ActorTerminationDelegate?
    var drop: Drop?
    
    var behavior: SoldierBehavior
    
    var animator: Animator!
    
    var anim: Float = 0
    
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
        
        body.mask = 0b100
        body.object = self
        body.noncolliding = true
        
        terminator = SoldierTerminator(self)
        
        animator = BaseMarchAnimator(body, 0.1, 0.15.m)
        animator.apply(display)
    }
    
    func damage(amount: Int) {
        if transform.location.y < -GameScreen.size.y + 0.5.m { return }
        health.damage(Float(amount))
    }
    
    override func update() {
        super.update()
        
        weapon?.update()
        behavior.update()
        
        if random(0, 1) < 0.0001 {
            behavior.push(TemporaryBehavior(MarchBehavior(self, BaseMarchAnimator(body, 0.05, 0.175.m)), 4))
        }
        
        terminate()
        updateShield()
    }
    
    func terminate() {
        if health.percent <= 0 {
            alive = false
            terminator?.terminate()
        }
    }
    
    func updateShield() {
        if let shield = health.shield {
            if shield.broke {
                shield.explode(transform)
            }
            shield.update()
        }
    }
    
}
