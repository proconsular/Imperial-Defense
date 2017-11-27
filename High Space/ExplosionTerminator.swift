//
//  ExplosionTerminator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/20/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class ExplosionTerminator: ActorTerminationDelegate {
    
    unowned let actor: Entity
    let radius: Float
    let color: float4
    
    init(_ actor: Entity, _ radius: Float, _ color: float4) {
        self.actor = actor
        self.radius = radius
        self.color = color
    }
    
    func terminate() {
        let explosion = Explosion(actor.transform.location, radius)
        explosion.color = color
        explosion.rate = 0.975
        Map.current.append(explosion)
        let audio = Audio("player-die")
        audio.volume = 1
        audio.start()
    }
    
}
