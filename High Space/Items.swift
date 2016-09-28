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
    let name: String
    
    init(_ location: float2, _ bounds: float2, _ radius: Float, _ name: String) {
        self.name = name
        range = BoundingCircle(location, radius)
        super.init(location, bounds)
    }
    
    func isUsable(_ location: float2) -> Bool {
        return range.contains(location)
    }
}

class Slot<T> {
    var item: T?
}

class Forge: Device {
    var slots: [Slot<Gem>]
    
    init(_ location: float2) {
        slots = []
        for _ in 0 ..< 5 {
            slots.append(Slot())
        }
        super.init(location, float2(0.5.m), 2.m, "Forge")
    }
    
    func combine() {
        var id = Gem.Identity([0, 0, 0, 0, 0, 0])
        let gems = getGems()
        for gem in gems {
            id = id + gem.identity
        }
        clear()
        slots[0].item = Gem(float2(), id)
    }
    
    private func clear() {
        slots = []
        for _ in 0 ..< 5 {
            slots.append(Slot())
        }
    }
    
    private func getGems() -> [Gem] {
        var gems: [Gem] = []
        
        for slot in slots {
            if let gem = slot.item {
                gems.append(gem)
            }
        }
        
        return gems
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

func +(alpha: Gem.Identity, beta: Gem.Identity) -> Gem.Identity {
    var values: [Int] = []
    for n in 0 ..< alpha.values.count {
        values.append(alpha.values[n] + beta.values[n])
    }
    return Gem.Identity(values)
}

class Gem: Item {

    struct Identity: Equatable {
        var values: [Int]
        
        init(_ values: [Int]) {
            self.values = values
        }
    }
    
    var identity: Identity
    
    init(_ location: float2, _ identity: Identity) {
        self.identity = identity
        super.init(location, float2(0.3.m))
        display.color = computeColor()
        body.tag = "rock"
        display.texture = GLTexture("gem").id
    }
    
    private func computeColor() -> float4 {
        var color = float4(1)
        for n in 0 ..< identity.values.count {
            let value = identity.values[n]
            color[n % 3] += Float(value) / 5
        }
        return color
    }
    
}



















