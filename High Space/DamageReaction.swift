//
//  DamageReaction.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class DamageReaction: HitReaction {
    unowned var object: Damagable
    
    init(_ object: Damagable) {
        self.object = object
    }
    
    func react(_ bullet: Bullet) {
        object.damage(bullet.impact.damage)
        bullet.terminator.terminate()
        let exp = Explosion(bullet.hitPoint, 0.25.m)
        exp.color = bullet.casing.color
        Map.current.append(exp)
    }
    
}
