//
//  LevelLayout.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LevelLayout {
    var rows: [LevelRow]
    
    init() {
        rows = []
    }
    
    var count: Int {
        var amount = 0
        for row in rows {
            amount += row.count
        }
        return amount
    }
}
