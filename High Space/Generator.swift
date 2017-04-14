//
//  GameData.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/16/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Difficulty {
    
    var level: Int
    var wave: Int
    var row: Int
    
    init(_ level: Int) {
        self.level = level
        wave = 0
        row = 0
    }
    
    var waves: Int {
        return GameData.info.level / 5 + 1
    }
    
    var size: Int {
        return clamp((wave / 4) + 3, min: 1, max: 10)
    }
    
    var amount: Int {
        return min(5 + Int(grade * 10), 18)
    }
    
    var grade: Float {
        return Float(level) * 0.01 + Float(wave) * 0.00625 + Float(row) * 0.025
    }
    
    var speed: Float {
        return clamp(Float(grade * 0.1), min: 0, max: 0.3)
    }
    
}

class LegionGenerator {
    
    let row_gen: RowGenerator
    var difficulty: Difficulty
    
    init(_ difficulty: Difficulty) {
        self.difficulty = difficulty
        self.row_gen = RowGenerator(difficulty)
    }
    
    func create() -> Legion {
        var rows: [Row] = []
        
        for i in 0 ..< difficulty.size {
            difficulty.row = i
            rows.append(row_gen.create(float2(Map.current.size.x / 2, -12.m - Float(i) * 2.m)))
        }
        
        return Legion(rows)
    }
    
}

class RowGenerator {
    
    let sol_gen: SoldierGenerator
    var difficulty: Difficulty
    
    init(_ difficulty: Difficulty) {
        self.difficulty = difficulty
        sol_gen = SoldierGenerator(difficulty)
    }
    
    func create(_ location: float2) -> Row {
        var soldiers: [Soldier] = []
        let amount = difficulty.amount
        let start = location + float2(-Float(amount) / 2 * 1.5.m, 0)
        for i in 0 ..< amount {
            let loc = start + float2(Float(i) * 1.5.m, 0)
            let soldier = sol_gen.create(loc)
            soldiers.append(soldier)
            Map.current.append(soldier)
        }
        return Row(soldiers)
    }
    
}

class SoldierGenerator {
    
    var difficulty: Difficulty
    
    init(_ difficulty: Difficulty) {
        self.difficulty = difficulty
    }
    
    func create(_ location: float2) -> Soldier {
        var soldier: Soldier!
        
        var index = 0
        while soldier == nil {
            let creator = ChanceTable.main.soldiers[index]
            let row = difficulty.row == 0 ? -1 : difficulty.row == difficulty.size - 1 ? 1 : 0
            if creator.chance.spawnable(difficulty.wave, row) {
                soldier = creator.create(location)
            }
            index = (index + 1) % ChanceTable.main.soldiers.count
        }
        
        if let marcher = soldier.animator as? MarchAnimator {
            marcher.rate -= difficulty.speed
        }
        
        return soldier
    }
    
}

class Chance {
    
    let wave: Int
    let row: Int
    let rank: Float
    
    init(_ wave: Int, _ rank: Float, _ row: Int) {
        self.wave = wave
        self.rank = rank
        self.row = row
    }
    
    func spawnable(_ wave: Int, _ row: Int) -> Bool {
        return self.row == row && isUnlocked(wave) && willSpawn(wave)
    }
    
    func willSpawn(_ wave: Int) -> Bool {
        return rank >= random(0, 1)
    }
    
    func isUnlocked(_ wave: Int) -> Bool {
        return wave >= self.wave
    }
    
}

class Creator<Product> {
    
    let producer: (float2) -> Product
    let chance: Chance
    
    init(_ producer: @escaping (float2) -> Product, _ chance: Chance) {
        self.producer = producer
        self.chance = chance
    }
    
    func create(_ location: float2) -> Product {
        return producer(location)
    }
    
}

class ArmorAugmentor {
    
    let weight: Int
    let color: float4
    let chance: Chance
    
    init(_ weight: Int, _ color: float4, _ chance: Chance) {
        self.weight = weight
        self.color = color
        self.chance = chance
    }
    
    func augment(_ soldier: Soldier) {
//        soldier.armor = weight
//        soldier.armor_image.color = color
    }
    
}

class ChanceTable {
    static let main = ChanceTable()
    
    var soldiers: [Creator<Soldier>]
    var armor: [ArmorAugmentor]
    
    init() {
        soldiers = []
        soldiers.append(Creator(Scout.init,     Chance(0, 0.75, -1)))
        
        soldiers.append(Creator(Soldier.init,   Chance(0, 0.5, -1)))
        soldiers.append(Creator(Soldier.init,   Chance(0, 0.75, 0)))
        soldiers.append(Creator(Soldier.init,   Chance(0, 0.5, 1)))
        
        soldiers.append(Creator(Banker.init,    Chance(0, 0.75, 1)))
        
        soldiers.append(Creator(Captain.init,   Chance(5, 0.25, 0)))
        soldiers.append(Creator(Healer.init,    Chance(15, 0.25, 0)))
        soldiers.append(Creator(Heavy.init,     Chance(30, 0.25, 1)))
        soldiers.append(Creator(Sniper.init,    Chance(40, 0.5, 1)))
        //soldiers.reverse()
        
        armor = []
//        armor.append(ArmorAugmentor(40, float4(1), Chance(20, 7)))
//        armor.append(ArmorAugmentor(80, float4(0, 0, 0.5, 1), Chance(40, 12)))
//        armor.append(ArmorAugmentor(200, float4(0.5, 0, 0, 1), Chance(20, 25)))
    }
    
}

class Roll {
    
    func next() -> Float {
        return Float.random()
    }
    
}


















