//
//  GraphicIndexer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/27/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol GraphicIndexer {
    func computeIndices(_ count: Int) -> [UInt16]
}

class PolygonIndexer: GraphicIndexer {
    
    func computeIndices(_ count: Int) -> [UInt16] {
        var indices: [UInt16] = []
        
        var m = 1
        for i in 0 ..< count / 2 {
            let i0 = i % 2 == 0
            let i1 = i % 2 == 1
            let ic = i == count - 1
            
            m += (i1 ? 2 : 0)
            indices.append(UInt16((i1 ? i + 1 : 0)))
            indices.append(UInt16(ic && i1 ? 1 : m))
            indices.append(UInt16((ic && i0 ? 1 : (i0 ? i + 2 : 0))))
        }
        
        return indices
    }
    
    
}

class DividedPolygonIndexer: GraphicIndexer {
    
    func computeIndices(_ count: Int) -> [UInt16] {
        var indices: [UInt16] = []
        
        var m = 1
        for i in 0 ..< count {
            let a = i % 2 == 1 ? i + 1 : 0
            let c = i % 2 == 0 ? i + 2 : 0
            m += i % 2 == 1 ? 2 : 0
            
            indices.append(UInt16(a))
            indices.append(UInt16(i == count - 1 && i % 2 == 1 ? 1 : m))
            indices.append(UInt16(i == count - 1 && i & 2 == 0 ? 1 : c))
        }
        
        return indices
    }
    
}
