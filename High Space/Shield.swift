//
//  Shield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Shield: StatusItem {
    var points: PointRange
    var damaged = false
    var timer: Timer!
    var baseColor: float4
    var color: float4
    var blink: Float = 0
    
    init(amount: Float) {
        baseColor = float4(0, 0.65, 1, 1)
        color = baseColor
        points = PointRange(amount)
        timer = Timer(2) {
            self.damaged = false
            if self.points.percent <= 0.9 {
                play("shield-re1")
            }
        }
    }
    
    var percent: Float {
        return points.percent
    }
    
    func damage(_ amount: Float) {
        damaged = true
        timer.increment = 0
        points.increase(-amount)
        playIfNot("hit8", 0.65)
    }
    
    func update() {
        if damaged {
            timer.update(Time.time)
            if percent <= 0.33 {
                blink += Time.time
                if blink >= 0.1 {
                    play("shield_weak")
                    blink = 0
                    color = color.x == 0 ? float4(1, 0, 0, 1) : baseColor
                }
            }else{
                color = baseColor
            }
        }else{
            color = baseColor
            if points.amount < points.limit {
                points.increase((points.limit * 0.5) * Time.time)
            }
        }
    }
}
