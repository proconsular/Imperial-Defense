//
//  FixedRect.swift
//  Relaci
//
//  Created by Chris Luttio on 9/15/14.
//  Copyright (c) 2017 Storiel, LLC. All rights reserved.
//

struct FixedRect {
    var location, halfbounds: float2
    
    init (_ location: float2, _ bounds: float2) {
        self.location = location
        self.halfbounds = bounds / 2
    }
    
    func contains (_ point: float2) -> Bool {
        return FixedRect.intersects(self, FixedRect(point, float2(2)))
    }
    
    static func intersects (_ prime: FixedRect, _ secunde: FixedRect) -> Bool {
        if abs(prime.location.x - secunde.location.x) > prime.halfbounds.x + secunde.halfbounds.x { return false }
        if abs(prime.location.y - secunde.location.y) > prime.halfbounds.y + secunde.halfbounds.y { return false }
        return true
    }
    
    func intersects(_ other: FixedRect) -> Bool {
        return FixedRect.intersects(self, other)
    }
    
    var bounds: float2 {
        get { return halfbounds * 2 }
        set { halfbounds = newValue / 2 }
    }
}

