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
        
        material["texture"] = GLTexture("bullet").id
        material.coordinates = SheetLayout(casing.tag == "player" ? casing.index != -1 ? casing.index : 1 : 0, 1, 4).coordinates
        //display.color = casing.color
        
        body.noncolliding = true
        body.callback = { [unowned self] (body, collision) in
            self.hit(body, collision)
        }
        
        body.velocity = impact.speed * direction
        body.orientation = atan2(direction.y, direction.x)
        body.mask = casing.tag == "player" ? 0b11 : 0b100
        body.object = self
    }
    
    override func compile() {
        BulletSystem.current.append(handle)
    }
    
    func hit(_ body: Body, _ collision: Collision) {
        if !self.alive {
            return
        }
        if let tag = body.tag, self.casing.tag == tag || self.casing.tag == "" {
            if let char = body.object as? Damagable {
                if char.reflective {
                    let dl = body.location - self.body.location
                    let dir = normalize(dl)
                    let normal = float2(-dir.y, dir.x)
                    let reflect = -(dl - 2 * dot(dl, normal) * normal)
                    self.body.velocity += normalize(reflect) * impact.speed
                    self.transform.orientation = atan2(reflect.y, reflect.x)
                    self.casing.tag = ""
                    self.body.mask = 0b111
                    return
                }else{
                    char.damage(impact.damage)
                }
            }
        }
        if let char = body.object as? Wall {
            char.damage(impact.damage)
        }
        self.alive = false
        let count = Int(random(3, 5))
        for _ in 0 ..< count {
            makeParts()
        }
    }
    
    func makeParts() {
        let spark = Particle(transform.location + normalize(body.velocity) * casing.size.x / 2, random(4, 9))
        spark.color = casing.color
        let velo: Float = 300
        spark.rate = 3.5
        spark.body.velocity = float2(random(-velo, velo), -normalize(body.velocity).y * random(0, velo))
        Map.current.append(spark)
    }
    
    override func update() {
        super.update()
        if casing.tag == "enemy" {
            let limit = -Camera.size.y + 1.m
            let percent: Float = 0.7
            var o = 1 - (body.location.y - limit * percent) / (limit - limit * percent)
            if body.location.y > limit * percent {
                o = 1
            }
            material.color = casing.color * o
//            display.refresh()
        }
    }
    
}

class HomingBullet: Bullet {
    
    var target: Entity
    
    init(_ location: float2, _ target: Entity, _ impact: Impact, _ casing: Casing) {
        self.target = target
        super.init(location, float2(), impact, casing)
    }
    
    override func update() {
        let dl = target.transform.location - transform.location
        body.orientation = atan2(dl.y, dl.x)
        if dl.length > 0 {
            body.velocity = impact.speed * normalize(dl)
        }
    }
    
}

protocol Damagable {
    var reflective: Bool { get set }
    func damage(_ amount: Float)
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
    var index: Int = -1
    var tag: String
    
    init(_ size: float2, _ color: float4, _ tag: String, _ index: Int = -1) {
        self.size = size
        self.color = color
        self.tag = tag
        self.index = index
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
        self.casing.size *= 2
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
    
    var charge: Float {
        return counter / rate
    }
    
}

class HomingFirer: Firer {
    
    func fire(_ location: float2, _ target: Entity) {
        let bullet = HomingBullet(location, target, computeFinalImpact(), casing)
        Map.current.append(bullet)
        counter = 0
    }
    
}















