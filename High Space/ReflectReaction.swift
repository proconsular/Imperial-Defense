//
//  ReflectReaction.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ReflectReaction: HitReaction {
    unowned let body: Body
    
    init(_ body: Body) {
        self.body = body
    }
    
    func react(_ bullet: Bullet) {
        let delta = body.location - bullet.body.location
        let direction = normalize(delta)
        let normal = float2(-direction.y, direction.x)
        let reflect = -(delta - 2 * dot(delta, normal) * normal)
        bullet.body.velocity = normalize(reflect) * bullet.impact.speed
        bullet.body.orientation = atan2(reflect.y, reflect.x)
        bullet.casing.tag = ""
        bullet.body.mask = 0b111
        Audio.play("reflect", 1)
    }
}
