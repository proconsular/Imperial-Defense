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












