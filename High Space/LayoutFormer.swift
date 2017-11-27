//
//  LayoutFormer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 9/5/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LayoutCreator {
    
    var info: BaseWaveInfo!
    var gap: Int!
    
    func create() -> LevelLayout {
        let layout = LevelLayout()
        
        let wave = GameData.info.wave
        
        info = BaseWaveInfo(wave)
        
        gap = info.computeGap()
        
        for rowIndex in 0 ..< info.depth {
            let row = LevelRow()
            
            if isBlankRow(rowIndex) {
                gap = info.computeGap()
                layout.rows.append(row)
                continue
            }
            
            for _ in 0 ..< info.computeRowWidth(rowIndex) {
                row.pieces.append(LevelPiece(info.isFilled))
                if layout.count + row.count >= info.max { break }
            }
            
            layout.rows.append(row)
            
            if layout.count >= info.max { break }
        }
        
        return layout
    }
    
    func isBlankRow(_ rowIndex: Int) -> Bool {
        return rowIndex % gap == 0 && rowIndex > 0 && randomInt(0, 10) <= info.structure
    }
    
}

protocol WaveInfo {
    var depth: Int { get }
    var max: Int { get }
    var startWidth: Int { get }
}

struct BaseWaveInfo: WaveInfo {
    var wave: Int
    
    init(_ wave: Int) {
        self.wave = wave
    }
    
    var depth: Int {
        var d = 6 + Int(Float(wave) / 3.5)
        if (wave + 1) % 5 == 0 && wave > 0 {
            d = Int(Float(d) * 1.25)
        }
        return d
    }
    
    var max: Int {
        var m = 50 + Int((Float(wave) / 50) * 90)
        
        if wave > 29 {
            m = 90 + Int((Float(wave - 29) / 10) * 20)
        }
        
        if wave > 39 {
            m = 100 + Int(Float(wave - 39) * 2)
        }
        
        if wave % 10 == 4 {
            m = 50 + 10 * Int(Float(wave) / 20)
        }
        
        if wave == 0 {
            m = 32
        }
        return m
    }
    
    var startWidth: Int {
        return clamp(7 + wave / 10, min: 5, max: 10)
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
        
        let wave = GameData.info.wave + 1
        
        let baseline: Float = 0.25 * (1 + (Float(wave - 1) / 25))
        let specialization = (Float((wave - 1) % 5) / 5) * 0.75 + baseline
        let class_level = Float(wave - 5) / 25
        
        let intensity: Float = specialization * 0.1 * (wave < 5 ? 0 : 1)
        
        let unit = 2 + Int(clamp(class_level * 6, min: 0, max: 6))
        
        let low_variance = Int(clamp(6, min: 0, max: 6))
        let high_variance = Int(clamp(0 * 6, min: 0, max: 6))
        
        for index in 0 ..< layout.rows.count {
            let row = layout.rows[index]
            
            for n in 0 ..< row.pieces.count {
                if row[n] == -1 || row[n] == 2 { continue }
                var id = unit
                id = 0.95 >= random(0, 1) ? unit + randomInt(-low_variance, 1 + high_variance) : id
                id = clamp(id, min: 2, max: 8)
                
                if isSpecialNear(row, n) || isSpecialClose(layout, index, n) {
                    continue
                }
                
                row[n] = intensity >= random(0, 1) ? id : row[n]
            }
            
        }
        
    }
    
    func isSpecialNear(_ row: LevelRow, _ n: Int) -> Bool {
        for i in 0 ..< 5 {
            let m = i - 2 + n
            if m < 0 || m >= row.pieces.count || m == n { continue }
            if row[m] >= 2 {
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

class LayoutGrader {
    
    func grade(_ layout: LevelLayout) -> Float {
        var value: Float = 0
        let average = computeAverageRowGrade(layout)
        
        for row in layout.rows {
            for piece in row.pieces {
                value += Float(piece.type + 1)
            }
            if row.count == 0 {
                value -= average / 2
            }
            if row.pieces.count >= 8 && row.count >= 8 {
                value += Float(row.pieces.count) / 2
            }
        }
        
        return value
    }
    
    func computeAverageRowGrade(_ layout: LevelLayout) -> Float {
        var value: Float = 0
        
        for row in layout.rows {
            for piece in row.pieces {
                value += Float(piece.type + 1)
            }
        }
        
        return value / Float(layout.count)
    }
    
}

class WaveGenerator {
    
    let creator: LayoutCreator
    let converter: LayoutConverter
    
    var modifiers: [LayoutModifier]
    
    let grader: LayoutGrader
    
    init() {
        creator = LayoutCreator()
        converter = LayoutConverter()
        grader = LayoutGrader()
        
        modifiers = []
        modifiers.append(BaseLayoutModifier())
        modifiers.append(SpecialLayoutModifier())
    }
    
    func generate() -> Legion {
        let layout = findBestLayout(75, 20)
        
        let grade = grader.grade(layout)
        let value = grade / computePowerGrade()
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        if let game = Game.instance {
            if let debug = game.layers[0] as? DebugLayer {
                debug.grade.setString("Grade: \(formatter.string(from: value as NSNumber)!)")
            }
        }
        
        return converter.convert(layout)
    }
    
    func findBestLayout(_ ideal: Float, _ iteration: Int) -> LevelLayout {
        var bestLayout = iterate()
        var bestGrade = computeGrade(bestLayout)
        
        for _ in 0 ..< iteration {
            let layout = iterate()
            let grade = computeGrade(layout)
            if fabsf(ideal - grade) < fabsf(ideal - bestGrade) {
                bestLayout = layout
                bestGrade = grade
            }
        }
        
        return bestLayout
    }
    
    func iterate() -> LevelLayout {
        let layout = creator.create()
        
        for modifier in modifiers {
            modifier.modify(layout)
        }
        
        return layout
    }
    
    func computeGrade(_ layout: LevelLayout) -> Float {
        return grader.grade(layout) / computePowerGrade()
    }
    
    func computePowerGrade() -> Float {
        return ((upgrader.firepower.range.amount + 1) * 3 + (upgrader.barrier.range.amount + 1) * 2 + (upgrader.shieldpower.range.amount + 1)) / 6
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
        map.updateValue(Producer(Captain.init), forKey: 2)
        map.updateValue(Producer(Heavy.init), forKey: 3)
        map.updateValue(Producer(Thief.init), forKey: 4)
        map.updateValue(Producer(Commander.init), forKey: 5)
        map.updateValue(Producer(Healer.init), forKey: 6)
        map.updateValue(Producer(Sniper.init), forKey: 7)
        map.updateValue(Producer(Mage.init), forKey: 8)
    }
    
    subscript(_ value: Int) -> Producer<Soldier> {
        get { return map[value]! }
    }
    
}
