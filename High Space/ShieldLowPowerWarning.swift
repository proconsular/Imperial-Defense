//
//  ShieldLowPowerWarning.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ShieldLowPowerWarning: PowerWarning {
    
    var color: float4
    var frequency: Float
    var threshold: Float
    
    var counter: Float
    var active: Bool
    
    var last: Float
    
    init(_ color: float4, _ frequency: Float, _ threshold: Float) {
        self.color = color
        self.frequency = frequency
        self.threshold = threshold
        counter = 0
        active = false
        last = 0
    }
    
    func update(_ percent: Float) {
        if percent > 0 && percent <= threshold {
            counter += Time.delta
            if counter >= frequency {
                counter = 0
                active = !active
                notify()
            }
        }else{
            active = false
        }
        last = percent
    }
    
    func notify() {
        let a = Audio("shield_weak")
        a.volume = 0.3
        a.start()
    }
    
    func apply(_ color: float4) -> float4 {
        return active ? self.color : color
    }
}
