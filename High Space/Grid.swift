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
    var actors: [Actor]
    var mask: FixedRect
    
    init(_ size: Float, _ bounds: float2) {
        self.size = size
        self.bounds = bounds
        self.index_bounds = int2(Int32(Int(bounds.x / size)), Int32(Int(bounds.y / size)))
        mask = FixedRect(float2(bounds.x / 2, -bounds.y / 2), bounds)
        cells = []
        actors = []
        for n in 0 ..< index_bounds.x {
            for m in 0 ..< index_bounds.y {
                cells.append(Cell(Placement(int2(Int32(n), Int32(m))), size))
            }
        }
    }
    
    func append(_ actor: Actor) {
        let cells = getCells(actor.bounds)
        cells.forEach{ $0.append(actor) }
        if cells.count > 0 {
            actors.append(actor)
        }
    }
    
    func remove(_ actor: Actor) {
        actors.removeObject(actor)
        if let location = transform(actor.body.location), let cell = getCell(location) {
            cell.elements = cell.elements.filter{ $0.element !== actor }
        }
    }
    
    private func insert(_ actor: Actor) {
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
    
    func getCells(_ rect: FixedRect) -> [Cell] {
        var c: [Cell] = []
        for cell in cells {
            if cell.mask.intersects(rect) {
                c.append(cell)
            }
        }
        return c
    }
    
    func update() {
        relocate()
        clean()
    }
  
    private func clean() {
        cells.forEach{ $0.clean() }
        actors = actors.filter{ $0.alive && contains(actor: $0) }
    }
    
    func contains(actor: Actor) -> Bool {
        return FixedRect.intersects(mask, actor.body.shape.getBounds())
    }
    
    private func relocate() {
        for cell in cells {
            let uncontained = cell.removeUncontainedElements().map{ $0.element }
            uncontained.forEach(insert)
        }
    }
    
    private func loop(_ action: (Placed<Actor>) -> ()) {
        for cell in cells {
            for placed in cell.elements {
                action(placed)
            }
        }
    }
    
    func getVisibleCells() -> [Cell] {
        return cells.filter{
            return Camera.contains(FixedRect($0.location, float2(size + 2.m)))
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
    let location: float2
    let mask: FixedRect
    var elements: [Placed<Actor>]
    
    init(_ placement: Placement, _ size: Float) {
        self.size = size
        self.placement = placement
        elements = []
        location = float2(Float(placement.location.x), -Float(placement.location.y)) * size
        mask = FixedRect(location + float2(size, -size) / 2, float2(size))
    }
    
    func append(_ element: Actor) {
        elements.append(Placed(placement, element))
    }
    
    var actors: [Actor] {
        return elements.map{ $0.element }
    }
    
    func clean() {
        elements = elements.filter{ $0.element.alive }
    }
    
    func contains(_ placed: Placed<Actor>) -> Bool {
        return mask.intersects(placed.element.body.shape.getBounds())
    }
    
    func removeUncontainedElements() -> [Placed<Actor>] {
        var uncontained: [Placed<Actor>] = []
        elements = elements.filter{
            if contains($0) { return true }
            uncontained.append($0)
            return false
        }
        return uncontained
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















