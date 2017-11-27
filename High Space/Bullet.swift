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
    var terminator: ActorTerminationDelegate!
    
    init(_ location: float2, _ direction: float2, _ impact: Impact, _ casing: Casing) {
        self.impact = impact
        self.casing = casing
        
        let rect = Rect(location, casing.size)
        super.init(rect, rect, Substance(PhysicalMaterial(.wood), Mass(0.05, 0), Friction(.iron)))
        
        let coords = SheetLayout(casing.tag == "player" ? casing.index != -1 ? casing.index : 1 : 0, 1, 4).coordinates
        material["texture"] = GLTexture("bullet").id
        material.coordinates = coords
        
        body.noncolliding = true
        body.callback = { [unowned self] (body, collision) in
            self.hit(body, collision)
        }
        
        body.velocity = impact.speed * direction
        body.orientation = atan2(direction.y, direction.x)
        
        body.mask = casing.tag == "player" ? 0b11 : 0b100
        body.object = self
        
        terminator = DefaultTerminator(self)
    }
    
    override func compile() {
        BulletSystem.current.append(handle)
    }
    
    func hit(_ body: Body, _ collision: Collision) {
        guard self.alive else { return }
        guard let object = body.object as? Hittable else { return }
        object.reaction?.react(self)
    }
    
}

class Missile: Bullet {
    var trail: TrailEffect!
    
    init(_ location: float2, _ direction: float2, _ casing: Casing) {
        super.init(location, direction, Impact(50, 16.m), casing)
        material["texture"] = GLTexture("Missile").id
        material.coordinates = [float2(0, 0), float2(1, 0), float2(1, 1), float2(0, 1)].rotate(1)
        terminator = MissileExplosion(self)
        
        trail = TrailEffect(self, 0.001, 8)
    }
    
    override func compile() {
        Graphics.create(handle)
    }
    
    override func update() {
        super.update()
        trail.update()
        
        if transform.location.y >= -0.5.m {
            terminator.terminate()
        }
    }
    
}

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
    
    init(_ actor: Entity) {
        self.actor = actor
    }
    
    func terminate() {
        Map.current.apply(FixedRect(actor.transform.location, float2(1.5.m))) { [unowned actor] in
            if let player = $0 as? Player {
                let dl = actor.transform.location - player.transform.location
                if dl.length <= 1.5.m {
                    player.damage((1 - dl.length / 1.5.m) * 30 + 15)
                }
            }
        }
        Explosion.create(actor.transform.location, 1.5.m, float4(1))
        Audio.start("explosion1", 3)
        actor.alive = false
    }
}

protocol HitReaction {
    func react(_ bullet: Bullet)
}

class DamageReaction: HitReaction {
    unowned let object: Damagable
    
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
        bullet.body.velocity += normalize(reflect) * bullet.impact.speed
        bullet.body.orientation = atan2(reflect.y, reflect.x)
        bullet.casing.tag = ""
        bullet.body.mask = 0b111
    }
    
}

class Spark {
    
    static func create(_ count: Int, _ body: Body, _ casing: Casing) {
        for _ in 0 ..< count {
            Spark.makeParts(body, casing)
        }
    }
    
    static func makeParts(_ body: Body, _ casing: Casing) {
        let spark = Particle(body.location + normalize(body.velocity) * casing.size.x / 2, random(4, 9))
        spark.color = casing.color
        let velo: Float = 300
        spark.rate = 3.5
        spark.body.velocity = float2(random(-velo, velo), -normalize(body.velocity).y * random(0, velo))
        Map.current.append(spark)
    }
    
}












