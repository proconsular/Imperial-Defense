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
    var borderActors: [Actor]
    
    init(_ size: Float, _ bounds: float2) {
        self.size = size
        self.bounds = bounds
        cells = []
        borderActors = []
    }
    
    func append(actor: Actor) {
        guard FixedRect.intersects(actor.body.shape.getBounds(), FixedRect(float2(bounds.x / 2, -bounds.y / 2), bounds)) else { return }
        let location = transform(actor.transform.location)
        if let cell = getCell(location) {
            cell.append(actor)
        }else{
            let cell = Cell(Placement(location))
            cell.append(actor)
            cells.append(cell)
        }
//        if onBorder(actor) {
//            borderActors.append(actor)
//        }
    }
    
    private func getCell(location: int2) -> Cell? {
        for cell in cells {
            if cell.placement.location == location {
                return cell
            }
        }
        return nil
    }
    
    func onBorder(actor: Actor) -> Bool {
        let loc = transform(actor.transform.location)
        let ext = transform(actor.transform.location + actor.body.shape.getBounds().bounds / 2)
        return loc != ext
    }
    
    func getNeighbors(location: int2) -> [Cell] {
        var neighbors: [Cell] = []
        
        let start = location.x - 1
        
        for n in 0 ..< 3 {
            let loc = int2(start + n, location.y)
            guard loc != location else { continue }
            if let cell = getCell(loc) {
                 neighbors.append(cell)
            }
        }
        
        return neighbors
    }
    
    private func transform(location: float2) -> int2 {
        return int2(Int(location.x / size), Int(location.y / size))
    }
    
    func query(location: float2, _ bounds: float2) -> [Cell] {
        let loc = transform(location)
        let ext = transform(bounds / 2)
        var inter: [Cell] = []
        let hs = Int(size / 2)
        for cell in cells {
            let right = cell.placement.location.x + hs >= loc.x - ext.x
            let left = cell.placement.location.x - hs <= loc.x + ext.x
            if right && left {
                inter.append(cell)
            }
        }
        return inter
    }
    
    func update() {
        removeDead()
        
        loop { $0.element.update() }
        loop { $0.element.onObject = false }
        
        removeBullets()
        relocate()
        
        //borderActors = borderActors.filter(onBorder)
        cells = cells.filter{ !$0.elements.isEmpty }
    }
    
    func getCellLocation(cell: Cell) -> float2 {
        return float2(Float(cell.placement.location.x), Float(cell.placement.location.y)) * size
    }
    
    private func removeBullets() {
        for cell in cells {
            cell.elements = cell.elements.filter{
                if let c = $0.element as? Bullet {
                    return c.active
                }
                return true
            }
        }
    }
    
    private func removeDead() {
        for cell in cells {
            cell.elements = cell.elements.filter{
                if let c = $0.element as? DreathActor {
                    return c.dreath.amount > 0
                }
                return true
            }
        }
    }
    
    private func relocate() {
        for cell in cells {
            cell.elements = cell.elements.filter{ placed in
                let newPlacement = transform(placed.element.transform.location)
                guard newPlacement != placed.placement.location else { return true }
                append(placed.element)
                return false
            }
        }
    }
    
    private func loop(@noescape action: Placed<Actor> -> ()) {
        for cell in cells {
            for placed in cell.elements {
                action(placed)
            }
        }
    }
    
    func render() {
        getVisibleCells().forEach{
            $0.actors.forEach{
                if Camera.visible($0.transform.location) {
                    $0.display.render()
                }
            }
        }
    }
    
    var actors: [Actor] {
        var list: [Actor] = []
        loop{ list.append($0.element) }
        return list
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
    let placement: Placement
    var elements: [Placed<Actor>]
    
    init(_ placement: Placement) {
        self.placement = placement
        elements = []
    }
    
    func append(element: Actor) {
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
    
    func computeIndex(width: Int) -> Int {
        return Int(location.x) + Int(location.y) * width
    }
}















