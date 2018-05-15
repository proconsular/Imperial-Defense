//
//  Spark.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Spark {
    
    static func create(_ count: Int, _ body: Body, _ casing: Casing) {
        for _ in 0 ..< count {
            Spark.makeParts(body, casing)
        }
    }
    
    static func makeParts(_ body: Body, _ casing: Casing) {
        let spark = Particle(body.location + normalize(body.velocity) * casing.size.x / 2, random(4, 9))
        spark.color = casing.color
        let velo: Float = 300
        spark.rate = 3.5
        spark.body.velocity = float2(random(-velo, velo), -normalize(body.velocity).y * random(0, velo))
        Map.current.append(spark)
    }
    
}
