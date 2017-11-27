//
//  Firer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/24/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

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
