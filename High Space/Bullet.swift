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
    
    var hitPoint: float2 {
        return transform.location + normalize(body.velocity) * casing.size.x / 2
    }
    
    override func compile() {
        BulletSystem.current.append(handle)
    }
    
    override func update() {
        super.update()
        body.orientation = atan2f(body.velocity.y, body.velocity.x)
        if body.location.x < 0 || body.location.x > Camera.size.x || body.location.y > 0 || body.location.y < -Map.current.size.y {
            terminator.terminate()
        }
    }
    
    func hit(_ body: Body, _ collision: Collision) {
        guard self.alive else { return }
        guard let object = body.object as? Hittable else { return }
        object.reaction?.react(self)
    }
    
}












