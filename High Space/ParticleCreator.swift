//
//  ParticleCreator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ParticleCreator {
    
    static func create(_ location: float2, _ bounds: float2, _ color: float4) {
        let spark = Particle(location + float2(random(-bounds.x / 2, bounds.x / 2), random(-bounds.y / 2, bounds.y / 2)), random(4, 9))
        spark.color = color
        let velo: Float = 400
        spark.rate = 2.5
        spark.body.velocity = float2(random(-velo, velo), random(-velo, velo))
        Map.current.append(spark)
    }
    
}
