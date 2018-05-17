//
//  LevelRow.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LevelRow {
    var pieces: [LevelPiece]
    
    init() {
        pieces = []
    }
    
    var count: Int {
        return pieces.filter{ $0.type >= 0 }.count
    }
    
    subscript(_ index: Int) -> Int {
        get {
            return pieces[index].type
        }
        set {
            pieces[index].type = newValue
        }
    }
}
