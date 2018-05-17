//
//  VertexInfo.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class VertexInfo {
    let scheme: VisualScheme
    
    init(_ scheme: VisualScheme) {
        self.scheme = scheme
    }
    
    var amountOfIndices: Int {
        return amountOfSides * 3
    }
    
    var amountOfSides: Int {
        return scheme.vertices.count
    }
    
    var amountOfNumbers: Int {
        return scheme.vertices.count * 2
    }
    
    var bufferSize: Int32 {
        return Int32(amountOfNumbers * 6 * MemoryLayout<Float>.size)
    }
}
