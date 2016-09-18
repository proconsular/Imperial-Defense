//
//  Grid.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/23/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation


class Grid {
    let size: Float
    let bounds: float2
    var cells: [Cell]
    var actors: [Actor]
    
    init(_ size: Float, _ bounds: float2) {
        self.size = size
        self.bounds = bounds
        cells = []
        actors = []
        for n in 0 ..< Int(bounds.x / size) {
            for m in 0 ..< Int(bounds.y / size) {
                cells.append(Cell(Placement(int2(n, m)), size))
            }
        }
    }
    
    func append(_ actor: Actor) {
        let cells = getCells(actor.body.shape.getBounds())
        cells.forEach{ $0.append(actor) }
        if cells.count > 0 {
            actors.append(actor)
        }
    }
    
    fileprivate func insert(_ actor: Actor) {
        let cells = getCells(actor.body.shape.getBounds())
        cells.forEach{ $0.append(actor) }
    }
    
    fileprivate func getCell(_ location: int2) -> Cell? {
        for cell in cells {
            if cell.placement.location == location {
                return cell
            }
        }
        return nil
    }
    
    func transform(_ location: float2) -> int2? {
        let x = location.x / size
        let y = location.y / size
        if !x.isFinite || !y.isFinite { return nil }
        return int2(Int(x), Int(y))
    }
    
    fileprivate func getCells(_ rect: FixedRect) -> [Cell] {
        var c: [Cell] = []
        for cell in cells {
            if FixedRect.intersects(cell.mask, rect) {
                c.append(cell)
            }
        }
        return c
    }
    
    func update() {
        clean()
        relocate()
    }
    
    func getCellLocation(_ cell: Cell) -> float2 {
        return float2(Float(cell.placement.location.x), -Float(cell.placement.location.y)) * size
    }
    
    fileprivate func clean() {
        for cell in cells where cell.elements.count > 0 {
            cell.elements = cell.elements.filter{
                return $0.element.alive
            }
        }
        actors = actors.filter{ $0.alive }
    }
    
    fileprivate func relocate() {
        for cell in cells where cell.elements.count > 0 {
            cell.elements = cell.elements.filter{ placed in
                if FixedRect.intersects(cell.mask, placed.element.body.shape.getBounds()) { return true }
                insert(placed.element)
                return false
            }
        }
    }
    
    fileprivate func loop(_ action: (Placed<Actor>) -> ()) {
        for cell in cells {
            for placed in cell.elements {
                action(placed)
            }
        }
    }
    
    func getVisibleCells() -> [Cell] {
        return cells.filter{
            let rect = FixedRect(getCellLocation($0), float2(size + 2.m))
            return Camera.contains(rect)
        }
    }
}

class Placed<Element> {
    let element: Element
    var placement: Placement
    
    init(_ placement: Placement, _ element: Element) {
        self.placement = placement
        self.element = element
    }
}

class Cell {
    let size: Float
    let placement: Placement
    let mask: FixedRect
    var elements: [Placed<Actor>]
    
    init(_ placement: Placement, _ size: Float) {
        self.size = size
        self.placement = placement
        mask = FixedRect(float2(Float(placement.location.x), -Float(placement.location.y)) * size + float2(size, -size) / 2, float2(size))
        elements = []
    }
    
    func append(_ element: Actor) {
        elements.append(Placed(placement, element))
    }
    
    func getTree() -> Quadtree {
        let tree = Quadtree(FixedRect(float2(Float(placement.location.x), Float(placement.location.y)) * 10.m + float2(5.m, -5.m), float2(10.m)))
        elements.map{ $0.element }.forEach(tree.append)
        return tree
    }
    
    var actors: [Actor] {
        return elements.map{ $0.element }
    }
}

struct Placement {
    var location: int2
    
    init(_ location: int2) {
        self.location = location
    }
    
    func computeIndex(_ width: Int) -> Int {
        return Int(location.x) + Int(location.y) * width
    }
}















