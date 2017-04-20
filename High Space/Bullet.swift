//
//  Bullet.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Bullet: Entity {
    var impact: Impact
    var casing: Casing
    
    init(_ location: float2, _ direction: float2, _ impact: Impact, _ casing: Casing) {
        self.impact = impact
        self.casing = casing
        
        let rect = Rect(location, casing.size)
        super.init(rect, rect, Substance(PhysicalMaterial(.wood), Mass(0.05, 0), Friction(.iron)))
        
        display.scheme.schemes[0].info.texture = GLTexture("bullet").id
        display.color = casing.color
        
        body.noncolliding = true
        body.callback = { (body, collision) in
            self.hit(body, collision)
        }
        
        body.velocity = impact.speed * direction
        body.orientation = atan2(direction.y, direction.x)
        body.mask = casing.tag == "player" ? 0b11 : 0b100
        body.object = self
    }
    
    func hit(_ body: Body, _ collision: Collision) {
        if !self.alive {
            return
        }
        if self.casing.tag == "enemy" {
            if let char = body.object as? Soldier {
                char.damage(amount: Int(impact.damage))
            }
            if !(body.object is Player) {
                self.alive = false
            }
        }
        if self.casing.tag == "player" {
            if let pla = body.object as? Player {
                pla.hit(amount: Int(impact.damage))
            }
            if !(body.object is Soldier) {
                self.alive = false
            }
        }
        if let char = body.object as? Wall {
            char.health -= Int(impact.damage)
        }
    }
    
}

struct Impact {
    var damage: Float
    var speed: Float
    
    init(_ damage: Float, _ speed: Float) {
        self.damage = damage
        self.speed = speed
    }
    
}

struct Casing {
    var size: float2
    var color: float4
    var tag: String
    
    init(_ size: float2, _ color: float4, _ tag: String) {
        self.size = size
        self.color = color
        self.tag = tag
    }
}

class Firer {
    
    var rate: Float
    var counter: Float
    
    var impact: Impact
    var casing: Casing
    
    var mods: [Impact]
    
    init(_ rate: Float, _ impact: Impact, _ casing: Casing) {
        self.rate = rate
        self.impact = impact
        self.casing = casing
        mods = []
        counter = 0
    }
    
    func update() {
        counter += Time.delta
    }
    
    func fire(_ location: float2, _ direction: float2) {
        let bullet = Bullet(location, direction, computeFinalImpact(), casing)
        Map.current.append(bullet)
        counter = 0
    }
    
    func computeFinalImpact() -> Impact {
        var final = impact
        for i in mods {
            final.damage += i.damage
            final.speed += i.speed
        }
        return final
    }
    
    var operable: Bool {
        return counter >= rate
    }
    
}















