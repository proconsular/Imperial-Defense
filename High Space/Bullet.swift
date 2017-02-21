//
//  Bullet.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Bullet: Actor {
    var info: BulletInfo
    
    init(_ location: float2, _ direction: float2, _ tag: String, _ info: BulletInfo) {
        self.info = info
        super.init(Rect(location, info.size), Substance(PhysicalMaterial(.wood), Mass(0.05, 0), Friction(.iron)))
        display.scheme.info.texture = GLTexture("bullet").id
        display.color = info.color
        body.noncolliding = true
        body.callback = { (body, collision) in
            if !self.alive {
                return
            }
            if tag == "enemy" {
                if let char = body.object as? Soldier {
                    char.damage(amount: self.info.damage)
                    //play("hit1", 1.5)
                }
                if !(body.object is Player) {
                    self.alive = false
                }
            }
            if tag == "player" {
                if let pla = body.object as? Player {
                    pla.hit(amount: self.info.damage)
                }
                if !(body.object is Soldier) {
                    self.alive = false
                }
            }
            if let char = body.object as? Wall {
                char.health -= self.info.damage
                //play("hit1", 1.5)
            }
            self.info.collide(self)
        }
        body.velocity = info.speed * direction
        body.orientation = atan2(direction.y, direction.x)
        body.mask = 0b01111
        body.object = self
    }
    
    override func update() {
        super.update()
    }
    
}
