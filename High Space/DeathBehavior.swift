//
//  DeathBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DeathBehavior: Behavior {
    var alive: Bool = true
    
    var timer: Float = 2
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
            let exp = Explosion(entity.transform.location, Camera.size.x)
            exp.rate = 0.98
            Map.current.append(exp)
            Audio.play("boss_wipeout")
        }
        
        blink += Time.delta
        if blink >= 0.01 {
            blink = 0
            if entity.material["color"] as! float4 == float4(1) {
                entity.material["color"] = float4(0, 0, 0, 1)
            }else{
                entity.material["color"] = float4(1)
            }
        }
        
    }
}
