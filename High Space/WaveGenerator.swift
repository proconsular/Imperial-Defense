//
//  WaveGenerator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
        
        let moderate = ModerateLayoutModifier()
        
        modifiers.append(moderate)
        modifiers.append(SpecialLayoutModifier())
    }
    
    func generate() -> Legion {
        let wave = GameData.info.wave + 1
        var ideal: Float = 75
        
        if wave % 5 == 0 && wave > 0 {
            ideal = 85
        }
        
        let layout = findBestLayout(ideal, 20)
        
        let grade = grader.grade(layout)
        let value = grade / computePowerGrade()
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        
        if debugDisplay {
            if let game = Game.instance {
                if let debug = game.layers[0] as? DebugLayer {
                    debug.grade.setString("Grade: \(formatter.string(from: value as NSNumber)!)")
                }
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
