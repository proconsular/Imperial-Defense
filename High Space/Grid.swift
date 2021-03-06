//
//  Grid.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/23/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Grid {
    let size: Float
    let bounds: float2
    let index_bounds: int2
    var cells: [Cell]
    let actorate: Actorate
    var mask: FixedRect
    
    init(_ size: Float, _ bounds: float2, _ actorate: Actorate) {
        self.size = size
        self.bounds = bounds
        self.actorate = actorate
        self.index_bounds = int2(Int32(Int(bounds.x / size)), Int32(Int(bounds.y / size)))
        mask = FixedRect(float2(bounds.x / 2, -bounds.y / 2), bounds)
        cells = []
        setup()
    }
    
    private func setup() {
        for n in 0 ..< index_bounds.x {
            for m in 0 ..< index_bounds.y {
                cells.append(Cell(Placement(int2(Int32(n), Int32(m))), size))
            }
        }
    }
    
    func append(_ actor: Entity) {
        let cells = getCells(actor.bounds)
        cells.forEach{ $0.append(actor) }
    }
    
    func remove(_ actor: Entity) {
        if let location = transform(actor.body.location), let cell = getCell(location) {
            cell.elements = cell.elements.filter{ $0 !== actor }
        }
    }
    
    private func insert(_ actor: Entity) {
        getCells(actor.bounds).forEach{ $0.append(actor) }
    }
    
    private func getCell(_ location: int2) -> Cell? {
        if location.x < 0 || location.x >= index_bounds.x { return nil }
        if location.y < 0 || location.y >= index_bounds.y { return nil }
        return cells[Int(location.x + location.y * index_bounds.x)]
    }
    
    func transform(_ location: float2) -> int2? {
        let x = location.x / size
        let y = location.y / size
        if !x.isFinite || !y.isFinite { return nil }
        return int2(Int32(Int(x)), Int32(Int(y)))
    }
    
    func restrict(_ location: int2) -> int2 {
        return int2(clamp(location.x, min: 0, max: index_bounds.x), clamp(location.y, min: 0, max: index_bounds.y))
    }
    
    func getCells(_ rect: FixedRect) -> [Cell] {
        var list: [Cell] = []
        let bounds = float2(rect.halfbounds.x, -rect.halfbounds.y)
        
        guard
            let st = transform(rect.location - bounds),
            let et = transform(rect.location + bounds) else
        { return [] }
        
        let start = restrict(st)
        let end = restrict(et)
        if start.x > end.x || start.y > end.y { return [] }
        for x in start.x ..< end.x + 1 {
            for y in start.y ..< end.y + 1 {
                let index = Int(x + y * index_bounds.x)
                if index >= 0 && index < cells.count {
                    list.append(cells[index])
                }
            }
        }
        return list
    }
    
    func update() {
        relocate()
    }
  
    func contains(actor: Entity) -> Bool {
        return mask.intersects(actor.bounds)
    }
    
    private func relocate() {
        cells.forEach{ $0.elements.removeAll() }
        actorate.actors.forEach(insert)
    }

    func getVisibleCells() -> [Cell] {
        return cells.filter{
            return Camera.current.contains(FixedRect($0.location, float2(size + 2.m)))
        }
    }
}
















