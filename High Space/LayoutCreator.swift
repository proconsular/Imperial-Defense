//
//  LayoutCreator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
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
