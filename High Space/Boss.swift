//
//  Boss.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/15/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class FinalBattle {
    
    static weak var instance: FinalBattle!
    
    unowned let emperor: Emperor
    
    init(_ emperor: Emperor) {
        self.emperor = emperor
        FinalBattle.instance = self
    }
    
    var challenge: Float {
        var out: Float = 0
        let c = 1 - emperor.health.stamina.percent
        let base = c / 6
        out = base
        if c > 0.25 {
            out = 0.25 + base
        }
        if c > 0.5 {
            out = 0.5 + base
        }
        if c > 0.75 {
            out = 0.75 + base
        }
        if c > 0.9 {
            out = 1
        }
        
        return clamp(out, min: 0, max: 1)
    }
    
}

class Lava: Entity {
    
    var timer: Float = 0
    
    init(_ location: float2) {
        let rect = Rect(location, float2(0.5.m))
        super.init(rect, rect, Substance.getStandard(0.1))
        display.texture = GLTexture("Lava").id
        display.coordinates = SheetLayout(0, 3, 3).coordinates
        body.noncolliding = true
    }
    
    override func update() {
        timer += Time.delta
        if timer >= 0.25 {
            timer = 0
            let r = 0.1.m
            let p = Particle(transform.location + float2(random(-r, 0.25.m), random(-0.25.m, 0.25.m)), random(2, 5))
            p.color = float4(1, 163 / 255, 26 / 255, 1)
            p.body.velocity = float2(0, -1.m)
            Map.current.append(p)
        }
    }
    
}
