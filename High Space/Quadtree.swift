//
//  Quadtree.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/25/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation


class Quadtree {
    let threshold = 10, depth_limit = 4
    
    let depth: Int
    let mask: FixedRect
    var sectors: [Quadtree]
    var elements: [Actor]
    
    init(_ mask: FixedRect, _ depth: Int = 0) {
        self.depth = depth
        self.mask = mask
        sectors = []
        elements = []
    }
    
    func append(actor: Actor) {
        if elements.count < threshold && sectors.isEmpty {
            elements.append(actor)
        }else{
            if depth < depth_limit {
                if sectors.isEmpty {
                    divide()
                    elements.forEach(insert)
                    elements.removeAll()
                }
                insert(actor)
            }else{
                elements.append(actor)
            }
        }
    }
    
    private func insert(actor: Actor) {
        for sector in sectors {
            if FixedRect.intersects(sector.mask, actor.body.shape.getBounds()) {
                sector.append(actor)
            }
        }
    }
    
    private func divide() {
        appendSector(1, 1)
        appendSector(-1, 1)
        appendSector(-1, -1)
        appendSector(1, -1)
    }
    
    private func appendSector(x: Float, _ y: Float) {
        sectors.append(Quadtree(FixedRect(mask.location + float2(x * mask.bounds.x, y * mask.bounds.y) / 4, mask.bounds / 2), depth + 1))
    }
}