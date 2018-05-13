//
//  Map.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/12/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Map {
    static var current: Map!
    
    let size: float2
    let grid: Grid
    
    var bullets: [Bullet]
    let actorate: Actorate
    
    init(_ size: float2) {
        self.size = size
        actorate = Actorate()
        grid = Grid(5.m, size, actorate)
        bullets = []
    }
    
    func append(_ element: Entity) {
        if let bullet = element as? Bullet {
            bullets.append(bullet)
        }
        actorate.append(element)
        grid.append(element)
        element.compile()
    }
    
    func remove(_ element: Entity) {
        actorate.remove(element)
        grid.remove(element)
    }
    
    func update() {
        updateBullets()
        updateObjects()
        grid.update()
        clean()
    }
    
    func updateBullets() {
        for b in bullets {
            for a in actorate.actors {
                if !(a is Bullet) {
                    if b.body.mask & a.body.mask > 0 && b.body.collide(a.body) {
                        b.body.callback(a.body, Collision())
                    }
                }
            }
        }
        bullets = bullets.filter{ $0.alive }
    }
    
    func getActors(rect: FixedRect) -> [Entity] {
        var list: [Entity] = []
        let cells = grid.getCells(rect)
        for cell in cells {
            for actor in cell.elements {
                if actor.bounds.intersects(rect) {
                    list.append(actor)
                }
            }
        }
        return list
    }
    
    func apply(_ rect: FixedRect, _ action: (Actor) -> ()) {
        let actors = getActors(rect: rect)
        for actor in actors {
            action(actor)
        }
    }
    
    private func updateObjects() {
        actorate.actors.forEach {
            $0.update()
            $0.onObject = false
        }
    }
    
    private func clean() {
        actorate.actors = actorate.actors.filter(isAlive)
    }
    
    func isAlive(_ actor: Entity) -> Bool {
        return actor.alive && (actor.bound ? grid.contains(actor: actor) : true)
    }
    
}






























