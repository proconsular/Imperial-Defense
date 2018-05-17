//
//  LayoutConverter.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
