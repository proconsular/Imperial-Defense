//
//  Data.swift
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
        return Data.info.level / 5 + 1
    }
    
    var size: Int {
        return clamp((Data.info.level / 4) + 1, min: 1, max: 10)
    }
    
    var amount: Int {
        return min(3 + Int(grade * 30), 18)
    }
    
    var grade: Float {
        return Float(level) * 0.01 + Float(wave) * 0.0125 + Float(row) * 0.025
    }
    
    var speed: Float {
        let rate = 0.5 - Float(wave) * 0.001 - Float(level / 4) * 0.02
        return clamp(rate, min: 0.25, max: 1)
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
            rows.append(row_gen.create(float2(Map.current.size.x / 2, -12.m - Float(i) * 1.25.m)))
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
        let start = location + float2(-Float(amount) / 2 * 1.m, 0)
        for i in 0 ..< amount {
            let loc = start + float2(Float(i) * 1.m, 0)
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
        let grade = difficulty.grade
        
        var soldier: Soldier!
        
        for creator in ChanceTable.main.soldiers {
            if creator.chance.spawnable(grade) {
                soldier = creator.create(location)
                break
            }
        }
        
        for augmentor in ChanceTable.main.armor {
            if augmentor.chance.spawnable(grade) {
                augmentor.augment(soldier)
            }
        }
        
        soldier.rate = difficulty.speed
        
        return soldier
    }
    
}

class Chance {
    
    let level: Int
    let probability: Float
    
    init(_ probability: Float, _ level: Int = 0) {
        self.probability = probability
        self.level = level
    }
    
    func spawnable(_ grade: Float) -> Bool {
        return willSpawn(grade) && unlocked
    }
    
    private func willSpawn(_ grade: Float) -> Bool {
        let gradient = UInt32(probability * (1 - grade))
        return (gradient > 0 ? Int(arc4random() % gradient) : 0) == 0
    }
    
    var unlocked: Bool {
        return Data.info.level >= level
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
        soldier.armor = weight
        soldier.armor_image.color = color
    }
    
}

class ChanceTable {
    static let main = ChanceTable()
    
    var soldiers: [Creator<Soldier>]
    var armor: [ArmorAugmentor]
    
    init() {
        soldiers = []
        soldiers.append(Creator(Soldier.init, Chance(0,  0)))
        soldiers.append(Creator(Sniper.init, Chance(30, 3)))
        soldiers.append(Creator(Captain.init, Chance(30, 6)))
        soldiers.append(Creator(Bomber.init, Chance(30, 9)))
        soldiers.append(Creator(LaserSoldier.init, Chance(30, 19)))
        soldiers.reverse()
        
        armor = []
        armor.append(ArmorAugmentor(40, float4(1), Chance(20, 7)))
        armor.append(ArmorAugmentor(80, float4(0, 0, 0.5, 1), Chance(40, 12)))
        armor.append(ArmorAugmentor(200, float4(0.5, 0, 0, 1), Chance(20, 25)))
    }
    
}

class Roll {
    
    func next() -> Float {
        return Float.random()
    }
    
}


















