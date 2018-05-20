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
                    Audio.play("immune", 0.6)
                }
            }
        }
        if let shield = soldier.health.shield {
            shield.set(1)
        }
    }
}
