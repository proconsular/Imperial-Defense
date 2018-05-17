//
//  DividedPolygonIndexer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
