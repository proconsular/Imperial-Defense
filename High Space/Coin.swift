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
    
    let timeout: Float = 4.5
    
    init(_ location: float2, _ points: Int) {
        self.points = points
        counter = timeout
        super.init(Rect(Transform(location), float2(0.4.m)), Substance.getStandard(0.01))
        display.texture = GLTexture("coin").id
        body.mask = 0b0
        display.scheme.schemes[0].order  = -1
        body.noncolliding = true
    }
    
    override func update() {
        super.update()
        if body.location.y > -0.5.m {
            body.location.y = -0.5.m
            body.velocity.y = 0
        }else{
            body.velocity.y += 1.m
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
        if FixedRect.intersects(body.shape.getBounds(), Player.player.body.shape.getBounds()) {
            alive = false
            //Map.current.append(TextParticle(transform.location, "+\(points)", 64))
            GameData.info.points += points
            let c = Audio("pickup1")
            c.volume = 0.4
            c.start()
        }
        counter -= Time.delta
        if counter <= 0 {
            alive = false
        }
        display.color = float4(counter / timeout)
        display.refresh()
    }
    
}
