//
//  Missile.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Missile: Bullet {
    var trail: TrailEffect!
    var counter: Counter
    
    init(_ location: float2, _ direction: float2, _ casing: Casing) {
        counter = Counter(0.05)
        super.init(location, direction, Impact(50, 16.m), casing)
        material["texture"] = GLTexture("Missile").id
        material.coordinates = [float2(0, 0), float2(1, 0), float2(1, 1), float2(0, 1)].rotate(1)
        terminator = MissileExplosion(self, 2.m)
        trail = TrailEffect(self, 0.001, 8)
    }
    
    override func compile() {
        Graphics.create(handle)
    }
    
    override func update() {
        super.update()
        trail.update()
        
        counter.update(Time.delta) {
            Audio.play("missile-move", 0.7)
        }
        
        if transform.location.y >= -0.5.m {
            terminator.terminate()
        }
    }
}








