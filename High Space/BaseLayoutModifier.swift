//
//  BaseLayoutModifier.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BaseLayoutModifier: LayoutModifier {
    
    func modify(_ layout: LevelLayout) {
        
        for index in 0 ..< layout.rows.count {
            let row = layout.rows[index]
            
            var rate: Float = clamp(0.1 - (Float(GameData.info.wave) / 250), min: 0, max: 1)
            
            if index == 0 {
                rate = clamp(0.7 - (Float(GameData.info.wave) / 35), min: 0, max: 1)
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
