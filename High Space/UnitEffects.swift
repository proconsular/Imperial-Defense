//
//  UnitEffects.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/5/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Immunity: Behavior {
    var alive: Bool = true
    
    unowned let soldier: Soldier
    var flicker: Float = 0
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func update() {
        if let mat = soldier.shield_material {
            mat.overlay = true
            flicker += Time.delta
            if flicker >= 0.05 {
                flicker = 0
                mat.overlay_color = mat.overlay_color.w == 1 ? float4(0.5) : float4(1)
                if mat.overlay_color.w == 1 {
                    Audio.play("immune", 0.05)
                }
            }
        }
        if let shield = soldier.health.shield {
            shield.set(1)
        }
    }
}

class Sprint: Behavior {
    var alive: Bool = true
    
    unowned let soldier: Soldier
    
    var counter: Float = 0
    var march: MarchBehavior
    
    init(_ soldier: Soldier, _ length: Float) {
        self.soldier = soldier
        counter = length
        march = MarchBehavior(soldier, soldier.animator)
    }
    
    func update() {
        if soldier.sprinter || !soldier.canSprint {
            alive = false
            return
        }
        counter -= Time.delta
        march.update()
        soldier.trail.update()
        soldier.animator.set(1)
        if counter <= 0 || !ActorUtility.spaceInFront(soldier, float2(0.75.m, 0)) {
            alive = false
            soldier.animator.set(0)
        }
    }
}
