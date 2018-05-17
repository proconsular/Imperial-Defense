//
//  BarrierConstructor.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BarrierConstructor {
    let layout: BarrierLayout
    var mods: [BarrierLayout]
    
    init(_ layout: BarrierLayout) {
        self.layout = layout
        mods = []
    }
    
    func construct(_ height: Float) -> [Wall] {
        let final = computeFinalLayout()
        var barriers: [Wall] = []
        for i in 0 ..< final.amount {
            let dis = 4.m
            let loc = Map.current.size.x / 2 + Float(i - final.amount / 2) * dis + dis / 2
            let wall = Wall(float2(loc, height), final.health)
            barriers.append(wall)
            Map.current.append(wall)
        }
        return barriers
    }
    
    func computeFinalLayout() -> BarrierLayout {
        var final = layout
        for m in mods {
            final.amount += m.amount
            final.health += m.health
        }
        return final
    }
}
