//
//  SpecialLayoutModifier.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class SpecialLayoutModifier: LayoutModifier {
    
    var map: [Int]
    
    init() {
        map = []
        
        let wave = GameData.info.wave + 1
        
        if wave >= 5 {
            map.append(2)
        }
        
        if wave >= 12 {
            map.append(3)
        }
        
        if wave >= 30 {
            map.append(5)
        }
        
        if wave >= 81 {
            map.append(6)
        }
        
        if wave >= 85 {
            map.append(7)
        }
        
    }
    
    func modify(_ layout: LevelLayout) {
        
        let wave = GameData.info.wave + 1
        
        var intensity: Float = 0.05
        
        if wave % 2 == 0 {
            intensity *= 2
        }
        
        for index in 0 ..< layout.rows.count {
            let row = layout.rows[index]
            
            for n in 0 ..< row.pieces.count {
                if row[n] == -1 || row[n] == 2 { continue }
                if wave < 5 { continue }
                let id = map[randomInt(0, map.count)]
                
                if isSpecialNearInRow(row, n) || isSpecialNearVertical(layout, index, n) {
                    continue
                }
                
                row[n] = intensity >= random(0, 1) ? id : row[n]
            }
            
        }
    }
    
    func isSpecialNearInRow(_ row: LevelRow, _ n: Int) -> Bool {
        let range = 8
        for i in 0 ..< range {
            let m = i - range / 2 + n
            if m < 0 || m >= row.pieces.count || m == n { continue }
            if row[m] >= 2 {
                return true
            }
        }
        return false
    }
    
    func isSpecialNearVertical(_ layout: LevelLayout, _ index: Int, _ n: Int) -> Bool {
        let center = layout.rows[index]
        let a = Float(n / center.count)
        for i in 0 ..< 3 {
            let m = i - 1 + index
            if m < 0 || m >= layout.rows.count || m == index { continue }
            let row = layout.rows[m]
            let b = Float(a * Float(row.count))
            return isSpecialNearInRow(row, Int(b))
        }
        return false
    }
    
}
