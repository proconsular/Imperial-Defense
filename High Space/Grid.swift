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
    
    init(_ size: Float, _ bounds: float2) {
        self.size = size
        self.bounds = bounds
        cells = []
        let count = Int(Game.levelsize / 10.m)
        for n in 0 ..< count {
            cells.append(Cell(Placement(int2(n, 0))))
        }
    }
    
    func append(actor: Actor) {
        if let cell = getCell(transform(actor.transform.location)) {
            cell.append(actor)
        }
    }
    
    private func getCell(location: int2) -> Cell? {
        for cell in cells {
            if cell.placement.location == location {
                return cell
            }
        }
        return nil
    }
    
    private func transform(location: float2) -> int2 {
        let x = location.x / size
        let y = location.y / size
        return int2(Int(x), Int(y))
    }
    
    func update() {
        removeDead()
        removeBullets()
        
        loop { $0.element.update() }
        loop { $0.element.onObject = false }
        
        relocate()
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
        cells.forEach{
            $0.actors.forEach{
                if Camera.visible($0.transform.location) {
                    $0.render()
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















