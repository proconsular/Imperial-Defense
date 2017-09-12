//
//  Creator.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 9/5/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
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

class LevelPiece {
    var type: Int
    
    init(_ type: Int) {
        self.type = type
    }
}







