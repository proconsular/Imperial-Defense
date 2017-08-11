//
//  Coin.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/8/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Coin: Entity {
    
    let points: Int
    var counter: Float
    
    let timeout: Float = 1
    
    init(_ location: float2, _ points: Int) {
        self.points = points
        counter = timeout
        let rect = Rect(Transform(location), float2(0.6.m))
        super.init(rect, rect, Substance.getStandard(0.01))
        material.texture = GLTexture("Crystal")
        material.coordinates = SheetLayout(0, 4, 1).coordinates
        body.mask = 0b0
        material.order = -1
        body.noncolliding = true
    }
    
    override func update() {
        if body.location.y > -0.5.m {
            body.location.y = -0.5.m
            body.velocity.y = 0
        }
        if body.location.x <= 1.m {
            body.location.x = 1.m
            body.velocity.x = 0
        }
        if body.location.x >= Camera.size.x - 1.m {
            body.location.x = Camera.size.x - 1.m
            body.velocity.x = 0
        }
        body.velocity *= 0.95
        counter -= Time.delta
        if counter <= 0 {
            pickup()
        }
    }
    
    func pickup() {
        alive = false
        GameData.info.points += points
        let c = Audio("pickup1")
        c.volume = 0.4
        c.start()
    }
    
}
