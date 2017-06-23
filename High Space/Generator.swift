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
        return clamp((wave / 6) + 4, min: 1, max: 10)
    }
    
    var amount: Int {
        return min(8 + Int(grade * 10), 18)
    }
    
    var grade: Float {
        return Float(level) * 0.01 + Float(wave) * 0.00625 + Float(row) * 0.025
    }
    
    var speed: Float {
        return clamp(Float(grade * 0.1), min: 0, max: 0.3)
    }
    
}

class GenerationContext {
    
    var banker: Int
    
    init() {
        banker = 0
    }
    
}

class Generator {
    
    var context: GenerationContext
    var difficulty: Difficulty
    
    init(_ context: GenerationContext, _ difficulty: Difficulty) {
        self.context = context
        self.difficulty = difficulty
    }
    
}

class LegionGenerator: Generator {
    
    let row_gen: RowGenerator
    
    init(_ difficulty: Difficulty) {
        let context = GenerationContext()
        self.row_gen = RowGenerator(context, difficulty)
        super.init(context, difficulty)
    }
    
    func create() -> Legion {
        var rows: [Row] = []
        
        for i in 0 ..< difficulty.size {
            difficulty.row = i
            let row = row_gen.create(float2(Map.current.size.x / 2, -12.m - Float(i) * 1.25.m))
            row.soldiers.forEach{ $0.display.order += -i }
            rows.append(row)
        }
        
        return Legion(rows)
    }
    
}

class RowGenerator: Generator {
    
    let sol_gen: SoldierGenerator
    
    override init(_ context: GenerationContext, _ difficulty: Difficulty) {
        sol_gen = SoldierGenerator(context, difficulty)
        super.init(context, difficulty)
    }
    
    func create(_ location: float2) -> Row {
        var soldiers: [Soldier] = []
        let amount = difficulty.amount
        let start = location + float2(-Float(amount) / 2 * 0.85.m, 0)
        for i in 0 ..< amount {
            let loc = start + float2(Float(i) * 0.85.m, 0)
            let soldier = sol_gen.create(loc)
            
            soldiers.append(soldier)
            Map.current.append(soldier)
        }
        return Row(soldiers)
    }
    
}

class SoldierGenerator: Generator {
    
    func create(_ location: float2) -> Soldier {
        var soldier: Soldier!
        
        var index = 0
        while soldier == nil {
            let creator = ChanceTable.main.soldiers[index]
            let row = difficulty.row == 0 ? -1 : difficulty.row == difficulty.size - 1 ? 1 : 0
            if creator.chance.spawnable(difficulty.wave, row) {
                let new = creator.create(location)
                if !(new is Banker) {
                    soldier = new
                }
                if (new is Banker && context.banker == 0) {
                    soldier = new
                    context.banker += 1
                }
            }
            index = (index + 1) % ChanceTable.main.soldiers.count
        }
        
//        if let marcher = soldier.animator as? MarchAnimator {
//            marcher.rate -= difficulty.speed
//        }
        
        return soldier
    }
    
}

class Chance {
    
    let wave: Int
    let row: Int
    let rank: Float
    let amount: Int
    
    init(_ wave: Int, _ rank: Float, _ row: Int, _ amount: Int = 0) {
        self.wave = wave
        self.rank = rank
        self.row = row
        self.amount = amount
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
        soldiers.append(Creator(Scout.init,     Chance(0, 0.5, -1)))
        soldiers.append(Creator(Scout.init,     Chance(0, 0.15, 0)))
        
        soldiers.append(Creator(Infrantry.init, Chance(0, 0.5, -1)))
        soldiers.append(Creator(Infrantry.init, Chance(0, 0.75, 0)))
        soldiers.append(Creator(Infrantry.init, Chance(0, 0.5, 1)))

        soldiers.append(Creator(Banker.init,    Chance(0, 0.75, 1, 1)))
        
        soldiers.append(Creator(Captain.init,   Chance(5, 0.25, 0)))
        soldiers.append(Creator(Heavy.init,     Chance(10, 0.35, 0)))
        soldiers.append(Creator(Thief.init,     Chance(15, 0.25, 0)))
        soldiers.append(Creator(Commander.init, Chance(20, 0.25, 0)))
        soldiers.append(Creator(Healer.init,    Chance(30, 0.3, 0)))
        
        soldiers.append(Creator(Sniper.init,    Chance(35, 0.25, -1)))
        soldiers.append(Creator(Sniper.init,    Chance(35, 0.25, 0)))
        soldiers.append(Creator(Sniper.init,    Chance(35, 0.25, 1)))
        soldiers.append(Creator(Mage.init,      Chance(40, 0.1, 0)))
        
        armor = []
    }
    
}

class Roll {
    
    func next() -> Float {
        return Float.random()
    }
    
}


















