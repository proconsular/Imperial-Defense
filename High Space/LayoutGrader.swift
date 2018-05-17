//
//  LayoutGrader.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LayoutGrader {
    
    let map = UnitValueMap()
    
    func grade(_ layout: LevelLayout) -> Float {
        var value: Float = 0
        let average = computeAverageRowGrade(layout)
        
        for row in layout.rows {
            for piece in row.pieces {
                value += map.get(piece.type)
            }
            if row.count == 0 {
                value -= average / 2
            }
            if row.pieces.count >= 8 && row.count >= 8 {
                value += Float(row.pieces.count) / 2
            }
            if row.pieces.count >= 10 && row.count >= 4 {
                value += Float(row.count) / 2
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
