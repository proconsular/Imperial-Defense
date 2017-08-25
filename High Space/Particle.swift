//
//  Particle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/13/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Particle: Entity {
    
    let size: Float
    var opacity: Float = 1
    var rate: Float = 1
    var color: float4 = float4(1)
    var guider: Guider?
    var drag = float2(1)
    
    init(_ location: float2, _ size: Float) {
        self.size = size
        let rect = Rect(Transform(location), float2(size))
        super.init(rect, rect, Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        material.order = 1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.delta
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        material.color = float4(opacity) * color
        guider?.update()
        body.velocity *= drag
    }
    
}

class DarkEnergy: Particle {
    
    override func update() {
        super.update()
        let dl = Player.player.transform.location - transform.global.location
        if dl.length <= size * 3 {
            Player.player.damage(10)
        }
    }
    
}

class Energy: Particle {
    
    override func update() {
        super.update()
        let actors = Map.current.getActors(rect: FixedRect(transform.location, float2(size * 4)))
        for actor in actors {
            if let bullet = actor as? Bullet {
                if bullet.casing.tag == "enemy" {
                    let dl = bullet.transform.location - transform.location
                    if dl.length <= size * 2 {
                        bullet.alive = false
                        alive = false
                    }
                }
            }
        }
    }
    
}

protocol Guider {
    func update()
}

class FollowGuider: Guider {
    
    let body: Body
    let target: Transform
    let speed: Float
    
    init(_ body: Body, _ target: Transform, _ speed: Float) {
        self.body = body
        self.target = target
        self.speed = speed
    }
    
    func update() {
        let dl = target.global.location - body.location
        body.velocity += normalize(dl) * speed
    }
    
}

class ParticleCreator {
    
    static func create(_ location: float2, _ bounds: float2, _ color: float4) {
        let spark = Particle(location + float2(random(-bounds.x / 2, bounds.x / 2), random(-bounds.y / 2, bounds.y / 2)), random(4, 9))
        spark.color = color
        let velo: Float = 400
        spark.rate = 2.5
        spark.body.velocity = float2(random(-velo, velo), random(-velo, velo))
        Map.current.append(spark)
    }
    
}

class Explosion: Entity {
    
    var opacity: Float = 1
    var radius: Float
    var color: float4 = float4(1)
    var rate: Float = 0.75
    var circle: Circle
    
    init(_ location: float2, _ radius: Float) {
        self.radius = radius
        circle = Circle(Transform(location), 0)
        super.init(circle, circle, Substance.getStandard(1))
        body.mask = 0b0
        material["order"] = 2
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity *= rate
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        circle.setRadius(radius * (1 - opacity))
        material["color"] = float4(opacity) * color
    }

}

class TextParticle: Entity {
    
    var opacity: Float = 1
    var rate: Float = 2.5
    var color: float4 = float4(1)
    var text: Text
    
    init(_ location: float2, _ string: String, _ size: Float) {
        text = Text(string, FontStyle(defaultFont, float4(1), size))
        text.location = location + float2(0, Camera.size.y)
        let rect = Rect(Transform(location), float2(size))
        super.init(rect, rect, Substance.getStandard(0.01))
        body.mask = 0b0
        color = float4(1, 1, 1, 1)
        material.order = 1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        opacity += -rate * Time.delta
        opacity = clamp(opacity, min: 0, max: 1)
        if opacity <= Float.ulpOfOne {
            alive = false
        }
        text.text.display.color = color * float4(opacity)
    }
    
    override func render() {
        text.text.display.refresh()
        text.render()
    }
    
}

class Rubble: Entity {
    
    init(_ location: float2) {
        let rect = Rect(location, float2(32 * 2))
        super.init(rect, rect, Substance.getStandard(1))
        material.order = 1
        body.noncolliding = true
        body.mask = 0b0
        
        material.texture = GLTexture("Rubble")
        material.coordinates = SheetLayout(randomInt(1, 2), 3, 1).coordinates
    }
    
}

class FallingRubble: Rubble {
    
    let target: float2
    let direction: float2
    
    init(_ location: float2, _ direction: float2) {
        target = location
        self.direction = direction
        let start = location + -direction * Camera.size.x
        super.init(start)
        bound = false
    }
    
    override func update() {
        body.velocity += direction * 20.m * Time.delta
        body.velocity *= 0.98
        
        let dt = (target - transform.location)
        if dt.length <= 0.5.m {
            alive = false
            Map.current.append(Explosion(target, 1.m))
            play("explosion1")
        }
        
        let dl = Player.player.transform.location - transform.location
        if dl.length <= 0.5.m {
            Player.player.damage(100)
            alive = false
        }
    }
    
}
















