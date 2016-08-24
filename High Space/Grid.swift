//
//  Grid.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/23/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation


protocol Map {
    
}

class Grid {
    let size: Float
    let bounds: float2
    var cells: [Cell<Actor>]
    
    
    init(_ size: Float, _ bounds: float2) {
        self.size = size
        self.bounds = bounds
        cells = []
    }
    
    func append(actor: Actor) {
        guard RawRect.isIntersected(actor.body.shape.getBounds(), RawRect(float2(0, -bounds.y / 2), bounds)) else { return }
        let location = transform(actor.transform.location)
        if let cell = getCell(location) {
            cell.append(actor)
        }else{
            let cell = Cell<Actor>(Placement(location))
            cell.append(actor)
            cells.append(cell)
        }
    }
    
    private func getCell(location: int2) -> Cell<Actor>? {
        for cell in cells {
            if cell.placement.location == location {
                return cell
            }
        }
        return nil
    }
    
    private func transform(location: float2) -> int2 {
        return int2(Int(location.x / size), Int(location.y / size))
    }
    
    func update() {
        loop { $0.element.update() }
        loop { $0.element.onObject = false }
        
        removeBullets()
        removeDead()
        relocate()
        
        cells = cells.filter{ !$0.elements.isEmpty }
    }
    
    func getCellLocation(cell: Cell<Actor>) -> float2 {
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
                if let c = $0.element as? Character {
                    return c.status.hitpoints.amount > 0
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
    
    var actors: [Actor] {
        var list: [Actor] = []
        loop{ list.append($0.element) }
        return list
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

class Cell<Element> {
    let placement: Placement
    var elements: [Placed<Element>]
    
    init(_ placement: Placement) {
        self.placement = placement
        elements = []
    }
    
    func append(element: Element) {
        elements.append(Placed(placement, element))
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















