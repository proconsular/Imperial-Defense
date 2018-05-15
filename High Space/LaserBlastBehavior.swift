//
//  LaserBlastBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LaserBlastBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    let laser: Laser
    var power: Float
    var angle, direction: Float
    var damage: Float
    
    var timer: Float = 0
    
    let speed: Float
    let length: Float
    
    unowned let shield: ParticleShield
    
    init(_ speed: Float, _ length: Float, _ laser: Laser, _ shield: ParticleShield) {
        self.speed = speed
        self.length = length
        self.laser = laser
        self.shield = shield
        power = length
        angle = Float.pi / 3
        laser.direction = float2(cosf(angle), sin(angle))
        direction = 1
        damage = 10
    }
    
    func activate() {
        active = true
        power = length
        laser.visible = true
        shield.set(CollapseEffect(power))
    }
    
    func update() {
        power -= Time.delta
        if power <= 0 {
            active = false
            laser.visible = false
            return
        }
        move()
        laser.visible = true
        collide()
    }
    
    func move() {
        if let player = Player.player {
            let dl = player.transform.location - Emperor.instance.transform.location
            let nor = normalize(dl)
            let da: Float = (atan2(nor.y, nor.x) - angle) > 0 ? 1 : -1
            angle += speed * da * Time.delta
            laser.direction = vectorize(angle)
        }
    }
    
    func collide() {
        let l = laser.rect
        if let player = Player.player {
            let p = player.body.shape
            let collision = PolygonSolver.solve(Polygon(p.transform, p.getVertices()), l)
            if collision != nil {
                Player.player.damage(damage)
            }
        }
        
    }
}
