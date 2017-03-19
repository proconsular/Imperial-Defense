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
    let actorate: Actorate
    var bullets: [Bullet]
    let renderer: Renderer
    
    init(_ size: float2) {
        self.size = size
        actorate = Actorate()
        grid = Grid(5.m, size, actorate)
        bullets = []
        renderer = Renderer(actorate)
    }
    
    func append(_ element: Entity) {
        if let bullet = element as? Bullet {
            bullets.append(bullet)
        }
        actorate.append(element)
        grid.append(element)
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
    
    private func updateObjects() {
        actorate.actors.forEach {
            $0.update()
            $0.onObject = false
        }
    }
    
    private func clean() {
        actorate.actors = actorate.actors.filter{ $0.alive && grid.contains(actor: $0) }
    }
    
    func render() {
//        actorate.actors.sorted{ $0.order < $1.order }.forEach{
//           // if Camera.visible($0.transform.location) {
//                $0.render()
//           // }
//        }
        renderer.render()
    }
    
}
