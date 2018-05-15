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
