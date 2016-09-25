//
//  Items.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/24/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Device: Structure {
    let range: BoundingCircle
    
    init(_ location: float2, _ bounds: float2, _ radius: Float) {
        range = BoundingCircle(location, radius)
        super.init(location, bounds)
    }
    
    func isUsable(_ location: float2) -> Bool {
        return range.contains(location)
    }
    
}

class Item: Actor {
    
    init(_ location: float2, _ bounds: float2) {
        super.init(Rect(location, bounds), Substance.StandardRotating(2, 0.0001))
        body.mask = 0b01
        body.object = self
    }
    
}

func ==(alpha: Gem.Identity, beta: Gem.Identity) -> Bool {
    guard alpha.values.count == beta.values.count else { return false }
    for n in 0 ..< alpha.values.count {
        if alpha.values[n] != beta.values[n] {
            return false
        }
    }
    return true
}

class Gem: Item {

    struct Identity: Equatable {
        var values: [Int]
        
        init(_ values: [Int]) {
            self.values = values
        }
    }
    
    let identity: Identity
    
    init(_ location: float2, _ identity: Identity) {
        self.identity = identity
        super.init(location, float2(0.3.m))
    }
    
}
