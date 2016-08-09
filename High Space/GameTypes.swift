//
//  GameTypes.swift
//  Bot Bounce 2
//
//  Created by Chris Luttio on 3/13/16.
//  Copyright © 2016 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class World {
    let terrain: Terrain
    var regulator: Regulator!
    
    init(_ principal: Principal) {
        terrain = Terrain(6)
        regulator = Regulator(GameAssembler(principal, terrain), terrain) { [unowned self] in
            principal.body.location.x + 60.m >= self.regulator.length
        }
    }
    
    func update() {
        regulator.regulate()
    }
    
    func render() {
        terrain.render()
    }
}



