//
//  BaseWaveInfo.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

struct BaseWaveInfo: WaveInfo {
    var wave: Int
    
    init(_ wave: Int) {
        self.wave = wave
    }
    
    var depth: Int {
        var d = 6 + Int(Float(wave) / 2.5)
        if (wave + 1) % 5 == 0 && wave > 0 {
            d = Int(Float(d) * 1.25)
        }
        return d
    }
    
    var max: Int {
        var m = 36 + Int((Float(wave) / 20) * 50)
        
        if wave >= 20 {
            m = 75
        }
        
        if wave > 0 && (wave + 1) % 5 == 0 {
            m = Int(Float(m) * 1.1)
        }
        
        return m
    }
    
    var startWidth: Int {
        return clamp(7 + wave / 10, min: 5, max: 8)
    }
    
    var variance: Int {
        var var_cycle: Float = 0
        
        if wave % 10 <= 4 {
            var_cycle = Float(wave % 5) / 5
        }else{
            var_cycle = 1 - Float(wave % 5) / 5
        }
        
        let variablity: Float = var_cycle
        
        return 1 + Int(clamp(variablity * 5, min: 0, max: 5))
    }
    
    var structure: Int {
        var dis_cycle: Float = 0
        
        if wave % 10 <= 4 {
            dis_cycle = Float(wave % 5) / 5
        }else{
            dis_cycle = 1 - Float(wave % 5) / 5
        }
        
        let disorder: Float = dis_cycle
        
        return 10 - Int(clamp(disorder * 6, min: 0, max: 6))
    }
    
    func computeGap() -> Int {
        return 3 + chaos
    }
    
    var chaos: Int {
        return randomInt(0, variance)
    }
    
    func computeRowWidth(_ rowIndex: Int) -> Int {
        let progressiveWidth = Int(Float(rowIndex) / 2) + chaos
        return clamp(startWidth + progressiveWidth, min: 1, max: 20)
    }
    
    var isFilled: Int {
        return randomInt(0, 10) <= structure ? 1 : -1
    }
}
