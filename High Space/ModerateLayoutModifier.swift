//
//  ModerateLayoutModifier.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ModerateLayoutModifier: LayoutModifier {
    
    var map: [Int] = []
    
    init() {
        let wave = GameData.info.wave + 1
        
        if wave >= 21 {
            map.append(4)
            map.append(8)
        }
        
        if wave >= 30 {
            map.append(10)
        }
        
        //        if wave >= 40 {
        //            map.append(11)
        //        }
        
        if wave >= 50 {
            map.append(9)
        }
    }
    
    func modify(_ layout: LevelLayout) {
        let wave = GameData.info.wave + 1
        
        var intensity: Float = 0.01
        
        if wave % 2 == 0 {
            intensity /= 2
        }
        
        if map.count == 0 { return }
        
        for index in 0 ..< layout.rows.count {
            let row = layout.rows[index]
            
            for n in 0 ..< row.pieces.count {
                if row[n] == -1 || row[n] == 2 { continue }
                let id = map[randomInt(0, map.count)]
                
                row[n] = intensity >= random(0, 1) ? id : row[n]
            }
            
        }
    }
    
}
