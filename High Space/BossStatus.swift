//
//  BossStatus.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossStatus {
    let status_shield, status_health: PercentDisplay
    
    init(_ health: Health) {
        let length = 40
        let loc = float2(Camera.size.x / 2, Camera.size.y * 0.7 - GameScreen.size.y)
        let shield_color = float4(48 / 255, 181 / 255, 206 / 255, 1)
        let health_color = float4(53 / 255, 215 / 255, 83 / 255, 1)
        status_shield = PercentDisplay(loc, 30, length, 1, LifeDisplayAdapter(health.shield!, shield_color))
        status_shield.frame.color = float4(0)
        status_health = PercentDisplay(loc, 30, length, 1, LifeDisplayAdapter(health.stamina, health_color))
        status_shield.move(-float2(status_shield.bounds.x / 2, 0))
        status_health.move(-float2(status_shield.bounds.x / 2, 0))
    }
    
    func update() {
        status_health.update()
        status_shield.update()
    }
    
    func render() {
        status_health.render()
        status_shield.render()
    }
}
