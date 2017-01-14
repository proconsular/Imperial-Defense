//
//  Map.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 9/12/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

extension Array where Element: AnyObject {
    
    mutating func removeObject(_ element: Element) {
        for n in 0 ..< self.count {
            if self[n] === element {
                self.remove(at: n)
                return
            }
        }
    }
    
}

class Map {
    
    static var current: Map!
    
    let size: float2
    let grid: Grid
    var actors: [Actor]
    var bullets: [Bullet]
    
    init(_ size: float2) {
        self.size = size
        actors = []
        grid = Grid(5.m, size)
        bullets = []
        Map.current = self
    }
    
    func append(_ element: Actor) {
        if let bullet = element as? Bullet {
            bullets.append(bullet)
        }
        actors.append(element)
        grid.append(element)
    }
    
    func remove(_ element: Actor) {
        actors.removeObject(element)
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
            for a in actors {
                if !(a is Bullet) {
                    if b.body.mask & a.body.mask > 0 && b.body.collide(a.body) {
                        b.body.callback(a.body, Collision())
                    }
                }
            }
        }
        bullets = bullets.filter{ $0.alive }
    }
    
    func getActors(rect: FixedRect) -> [Actor] {
        var list: [Actor] = []
        let cells = grid.getCells(rect)
        for cell in cells {
            for actor in cell.actors {
                if FixedRect.intersects(actor.body.shape.getBounds(), rect) {
                    list.append(actor)
                }
            }
        }
        return list
    }
    
    private func updateObjects() {
        actors.forEach {
            $0.update()
            $0.onObject = false
        }
    }
    
    private func clean() {
        actors = actors.filter{ $0.alive && grid.contains(actor: $0) }
    }
    
    func render() {
        actors.sorted{ $0.order < $1.order }.forEach{
           // if Camera.visible($0.transform.location) {
                $0.render()
           // }
        }
    }
    
}
