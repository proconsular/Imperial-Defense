//
//  ActorUtility.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ActorUtility {
    
    static func hasLineOfSight(_ actor: Entity) -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(float2(actor.transform.location.x, actor.transform.location.y + Camera.size.y / 2 + actor.body.shape.getBounds().bounds.y), float2(0.5.m, Camera.size.y)))
        for a in actors {
            if a is Soldier {
                return false
            }
        }
        return true
    }
    
    static func spaceInFront(_ actor: Entity, _ bounds: float2) -> Bool {
        let actors = Map.current.getActors(rect: FixedRect(float2(actor.transform.location.x, actor.transform.location.y + actor.body.shape.getBounds().bounds.y / 2), bounds))
        for a in actors {
            if a !== actor {
                if a is Soldier {
                    return false
                }
            }
        }
        return true
    }
    
}
