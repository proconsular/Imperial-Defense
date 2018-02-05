//
//  MissileExplosion.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class DefaultTerminator: ActorTerminationDelegate {
    unowned let actor: Actor
    
    init(_ actor: Actor) {
        self.actor = actor
    }
    
    func terminate() {
        actor.alive = false
    }
}

class MissileExplosion: ActorTerminationDelegate {
    unowned let actor: Entity
    let radius: Float
    
    init(_ actor: Entity, _ radius: Float) {
        self.actor = actor
        self.radius = radius
    }
    
    func terminate() {
        Map.current.apply(FixedRect(actor.transform.location, float2(radius))) { [unowned actor, unowned self] in
            if let player = $0 as? Player {
                let dl = actor.transform.location - player.transform.location
                if dl.length <= self.radius {
                    player.damage((1 - dl.length / self.radius) * 30 + 15)
                }
            }
        }
        Explosion.create(actor.transform.location, radius, float4(1))
        Audio.play("missile-explode", 0.7)
        actor.alive = false
    }
}
