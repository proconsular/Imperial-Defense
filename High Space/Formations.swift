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
    
    var difficulty: Difficulty
    
    init(_ mode: Int) {
        difficulty = Difficulty(GameData.info.level)
        generator = WaveGenerator()
        count = 100
        Coordinator.wave = 0
        waves = []
    }
    
    func setWave(_ wave: Int) {
        Coordinator.wave = wave
        difficulty.wave = wave
        count = 100 - wave
    }
    
    func next() {
        count -= 1
        Coordinator.wave += 1
        difficulty.wave = Coordinator.wave
        
        if GameData.info.wave >= 49 {
            let emp = Emperor(float2(Camera.size.x / 2, -Camera.size.y + 3.m))
            let legion = Legion([Row([emp])])
            Map.current.append(emp)
            waves.append(legion)
        }else{
            waves.append(generator.generate())
        }
    }
    
    var empty: Bool {
        return waves.first?.health ?? 0 <= 0
    }
    
    func update() {
        if let front = waves.first {
            front.update()
        }
    }
    
}

protocol Battalion {
    var health: Int { get }
    
    func update()
}

class Legion: Battalion {
    
    var rows: [Row]
    
    init(_ rows: [Row]) {
        self.rows = rows
    }
    
    func update() {
        rows.forEach{
            $0.update()
        }
        rows = rows.filter{ $0.soldiers.count > 0 }
    }
    
    var health: Int {
        var sum = 0
        rows.forEach{ sum += $0.health }
        return sum
    }
    
}

class Row: Battalion {
    
    var soldiers: [Soldier]
    var amount: Int
    
    init(_ soldiers: [Soldier]) {
        self.soldiers = soldiers
        amount = soldiers.count
    }
    
    func update() {
        soldiers = soldiers.filter{ $0.alive }
    }
    
    var health: Int {
        return soldiers.count
    }
    
}
