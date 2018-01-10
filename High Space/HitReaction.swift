//
//  HitReaction.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol HitReaction {
    func react(_ bullet: Bullet)
}

class DamageReaction: HitReaction {
    unowned var object: Damagable
    
    init(_ object: Damagable) {
        self.object = object
    }
    
    func react(_ bullet: Bullet) {
        object.damage(bullet.impact.damage)
        Spark.create(randomInt(3, 5), bullet.body, bullet.casing)
        bullet.terminator.terminate()
    }
    
}

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
    }
}





















