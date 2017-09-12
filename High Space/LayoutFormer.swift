//
//  LayoutFormer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 9/5/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LayoutCreator {
    
    func create() -> LevelLayout {
        let layout = LevelLayout()
        
        let wave = GameData.info.wave
        
        var max = 50 + Int((Float(wave) / 50) * 125)
        
        if wave > 29 {
            max = 90 + Int((Float(wave - 29) / 10) * 20)
        }
        
        if wave > 39 {
            max = 100 + Int(Float(wave - 39) * 2)
        }
        
        if wave % 10 == 4 {
            max = 50 + 20 * Int(Float(wave) / 20)
        }
        
        var depth = 6 + Int(Float(wave) / 3.5)
        
        if (wave + 1) % 5 == 0 && wave > 0 {
            depth = Int(Float(depth) * 1.25)
        }
        
        if wave == 0 {
            max = 32
        }
        
        let startWidth = clamp(7 + wave / 10, min: 5, max: 10)
        
        var var_cycle: Float = 0
        var dis_cycle: Float = 0
        
        if wave % 10 <= 4 {
            var_cycle = Float(wave % 5) / 5
            dis_cycle = Float(wave % 5) / 5
        }else{
            var_cycle = 1 - Float(wave % 5) / 5
            dis_cycle = 1 - Float(wave % 5) / 5
        }
        
        let variablity: Float = var_cycle
        let disorder: Float = dis_cycle
        
        let variance = 1 + Int(clamp(variablity * 5, min: 0, max: 5))
        let structure = 10 - Int(clamp(disorder * 6, min: 0, max: 6))
        
        var gap = 3 + randomInt(0, variance)
        
        for d in 0 ..< depth {
            let row = LevelRow()
            
            if d % gap == 0 && d > 0 && randomInt(0, 10) <= structure {
                gap = 3 + randomInt(0, variance)
                layout.rows.append(row)
                continue
            }
            
            let count = clamp(startWidth + Int(Float(d) / 2) + randomInt(0, variance), min: 1, max: 20)
            
            for _ in 0 ..< count {
                let id = randomInt(0, 10) <= structure ? 1 : -1
                row.pieces.append(LevelPiece(id))
                if layout.count + row.count >= max { break }
            }
            
            layout.rows.append(row)
            
            if layout.count >= max { break }
        }
        
        return layout
    }
    
    func cycleValue(_ value: Int, _ limit: Int) -> Float {
        let i = Float(value > 0 ? value % limit : 0)
        return i / Float(limit)
    }
    
}

protocol LayoutModifier {
    func modify(_ layout: LevelLayout)
}

class BaseLayoutModifier: LayoutModifier {
    
    func modify(_ layout: LevelLayout) {
        
        for index in 0 ..< layout.rows.count {
            let row = layout.rows[index]
            
            var rate: Float = 0.1
            
            if index == 0 {
                rate = 0.7
            }
            
            for n in 0 ..< row.pieces.count {
                if row[n] == -1 { continue }
                row[n] = rate >= random(0, 1) ? 0 : row[n]
            }
        }
        
        let last = getLastRow(layout)!
        last[randomInt(0, last.pieces.count)] = 2
    }
    
    func getLastRow(_ layout: LevelLayout) -> LevelRow! {
        let rows = layout.rows.reversed()
        for row in rows {
            if row.pieces.count > 0 {
                return row
            }
        }
        return nil
    }
    
}

class SpecialLayoutModifier: LayoutModifier {
    
    func modify(_ layout: LevelLayout) {
        
        let wave = GameData.info.wave
        
        let specialization = (Float(wave % 5) / 5) * 0.75 + 0.25
        let class_level = Float(wave + 1 - 5) / 25
        
        let intensity: Float = specialization * 0.1 * (wave + 1 < 5 ? 0 : 1)
        let level: Float = class_level
        let low_variety: Float = specialization
        let high_variety: Float = 0
        
        let amount = intensity * 0.75
        let unit = 3 + Int(clamp(level * 5, min: 0, max: 5))
        let low_variance = Int(clamp(low_variety * 6, min: 0, max: 6))
        let high_variance = Int(clamp(high_variety * 6, min: 0, max: 6))
        
        for index in 0 ..< layout.rows.count {
            let row = layout.rows[index]
            
            for n in 0 ..< row.pieces.count {
                if row[n] == -1 || row[n] == 2 { continue }
                var id = unit
                id = 0.95 >= random(0, 1) ? unit + randomInt(-low_variance, 1 + high_variance) : id
                id = clamp(id, min: 3, max: 9)
                
                if isSpecialNear(row, n) || isSpecialClose(layout, index, n) {
                    continue
                }
                
                row[n] = amount >= random(0, 1) ? id : row[n]
            }
            
        }
        
    }
    
    func isSpecialNear(_ row: LevelRow, _ n: Int) -> Bool {
        for i in 0 ..< 5 {
            let m = i - 2 + n
            if m < 0 || m >= row.pieces.count || m == n { continue }
            if row[m] >= 3 {
                return true
            }
        }
        return false
    }
    
    func isSpecialClose(_ layout: LevelLayout, _ index: Int, _ n: Int) -> Bool {
        let center = layout.rows[index]
        let a = Float(n / center.count)
        for i in 0 ..< 3 {
            let m = i - 1 + index
            if m < 0 || m >= layout.rows.count || m == index { continue }
            let row = layout.rows[m]
            let b = Float(a * Float(row.count))
            return isSpecialNear(row, Int(b))
        }
        return false
    }
    
}

class LayoutConverter {
    
    let map: SoldierMapper
    
    init() {
        map = SoldierMapper()
    }
    
    func convert(_ layout: LevelLayout) -> Legion {
        var rows: [Row] = []
        
        let spacing = float2(0.75.m, 0.75.m)
        let start = float2(Camera.size.x / 2, -Camera.size.y - 2.m)
        var offset = float2()
        
        var order = 0
        
        for row in layout.rows {
            var list: [Soldier] = []
            
            offset.x = -Float(row.pieces.count) / 2 * spacing.x - spacing.x / 2
            
            for piece in row.pieces {
                if piece.type >= 0 {
                    let soldier = map[piece.type].produce(start + offset + float2(spacing.x, 0))
                    soldier.material["order"] = -order
                    Map.current.append(soldier)
                    list.append(soldier)
                }
                
                offset.x += spacing.x
            }
            
            order += 1
            
            offset.x = 0
            offset.y += -spacing.y * (row.pieces.isEmpty ? 2 : 1)
            rows.append(Row(list))
        }
        
        return Legion(rows)
    }
    
}

class WaveGenerator {
    
    let creator: LayoutCreator
    let converter: LayoutConverter
    
    var modifiers: [LayoutModifier]
    
    init() {
        creator = LayoutCreator()
        converter = LayoutConverter()
        
        modifiers = []
        modifiers.append(BaseLayoutModifier())
        modifiers.append(SpecialLayoutModifier())
    }
    
    func generate() -> Legion {
        let layout = creator.create()
        
        for modifier in modifiers {
            modifier.modify(layout)
        }
        
        return converter.convert(layout)
    }
    
}

class Producer<Product> {
    var produce: (float2) -> Product
    
    init(_ produce: @escaping (float2) -> Product) {
        self.produce = produce
    }
}

class SoldierMapper {
    
    var map: [Int: Producer<Soldier>]
    
    init() {
        map = [:]
        
        map.updateValue(Producer(Scout.init), forKey: 0)
        map.updateValue(Producer(Infrantry.init), forKey: 1)
        map.updateValue(Producer(Banker.init), forKey: 2)
        map.updateValue(Producer(Captain.init), forKey: 3)
        map.updateValue(Producer(Heavy.init), forKey: 4)
        map.updateValue(Producer(Thief.init), forKey: 5)
        map.updateValue(Producer(Commander.init), forKey: 6)
        map.updateValue(Producer(Healer.init), forKey: 7)
        map.updateValue(Producer(Sniper.init), forKey: 8)
        map.updateValue(Producer(Mage.init), forKey: 9)
    }
    
    subscript(_ value: Int) -> Producer<Soldier> {
        get { return map[value]! }
    }
    
}
