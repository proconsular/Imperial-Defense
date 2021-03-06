//
//  Formations.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Coordinator {
    var waves: [Battalion]
    var count: Int
    
    static var wave: Int = 0
    
    let generator: WaveGenerator
    
    init(_ wave: Int) {
        generator = WaveGenerator()
        count = 1
        Coordinator.wave = wave
        waves = []
    }
    
    func setWave(_ wave: Int) {
        Coordinator.wave = wave
        count = 1
    }
    
    func next() {
        count -= 1
        Coordinator.wave += 1
        
        if GameData.info.wave >= 100 {
            let emp = Emperor(float2(Camera.size.x / 2, -Camera.size.y))
            let legion = Legion([Row([emp])])
            Map.current.append(emp)
            waves.append(legion)
        }else{
            waves.append(generator.generate())
        }
    }
    
    var empty: Bool {
        return waves.first?.health ?? 0 <= 0 && count <= 0
    }
    
    func update() {
        if let front = waves.first {
            front.update()
        }
    }
    
}
