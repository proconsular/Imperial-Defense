//
//  BlastEffect.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BlastEffect {
    
    var transform: Transform
    var bounds: float2
    
    init(_ transform: Transform, _ bounds: float2) {
        self.transform = transform
        self.bounds = bounds
    }
    
    func generate() {
        let count = random(10, 20)
        for _ in 0 ..< Int(count) {
            spawn()
        }
    }
    
    func spawn() {
        let spark = Particle(transform.location + float2(random(-bounds.x / 2, bounds.x / 2), random(-bounds.y / 2, bounds.y / 2)), random(4, 9))
        let col = random(0.5, 0.75)
        spark.color = float4(col, col, col, 1)
        let velo: Float = 400
        spark.body.relativeGravity = 1
        spark.rate = 0.5
        spark.body.velocity = float2(random(-velo, velo) / 2, random(-velo, -velo / 2))
        Map.current.append(spark)
    }
    
}
