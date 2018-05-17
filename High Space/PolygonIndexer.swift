//
//  PolygonIndexer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/15/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

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
