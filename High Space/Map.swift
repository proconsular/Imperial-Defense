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
    
    var renderSystem: MapRenderSystem
    
    init(_ size: float2) {
        self.size = size
        actorate = Actorate()
        grid = Grid(5.m, size, actorate)
        bullets = []
        renderSystem = FlatRenderSystem(actorate)
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
    
    private func updateObjects() {
        actorate.actors.forEach {
            $0.update()
            $0.onObject = false
        }
    }
    
    private func clean() {
//        let dead = actorate.actors.filter{ !isAlive($0) }
//        for d in dead {
//            d.handle.alive = false
//        }
        actorate.actors = actorate.actors.filter(isAlive)
    }
    
    func isAlive(_ actor: Entity) -> Bool {
        return actor.alive && (actor.bound ? grid.contains(actor: actor) : true)
    }
    
    func render() {
        //renderSystem.render()
    }
    
}

protocol ActorMap {
    var actors: [Entity] { get set }
}

protocol MapRenderSystem {
    var map: ActorMap { get set }
    func render()
}

class FlatRenderSystem: MapRenderSystem {
    var map: ActorMap
    
    init(_ map: ActorMap) {
        self.map = map
    }
    
    func render() {
        sortActors().forEach{
            //if Camera.current.visible($0.display) {
//                $0.display.refresh()
                $0.render()
            //}
        }
    }
    
    func sortActors() -> [Entity] {
        return map.actors.sorted{ $0.material.texture.id < $1.material.texture.id }.sorted{ $0.material.order < $1.material.order }
    }
    
}

class GroupRenderSystem: MapRenderSystem {
    var map: ActorMap
    
    init(_ map: ActorMap) {
        self.map = map
    }
    
    func render() {
//        let batches = compile()
//        for batch in batches {
//            batch.render()
//        }
    }
    
}

































