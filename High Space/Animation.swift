//
//  Animation.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 4/9/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class TextureAnimator {
    
    var index: Int
    var width: Int
    var height: Int
    var length: Int
    var bounds: float2
    var offset: Int?
    
    init(_ length: Int, _ width: Int, _ height: Int, _ bounds: float2) {
        self.width = width
        self.height = height
        self.length = length
        self.bounds = bounds
        index = 0
    }
    
    var coordinates: [float2] {
        var coords: [float2] = []
        
        let frame = float2(bounds.x / Float(width), bounds.y / Float(height))
        let x = index % width
        let y = index / width
        let location = float2(Float(x), Float(y)) * frame
        
        coords = [location, float2(location.x, location.y + frame.y), location + frame, float2(location.x + frame.x, location.y)]
        
        return coords
    }
    
    func animate() {
        index = (offset ?? 0) + (index + 1) % length
    }
    
}
