//
//  Dreath.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/18/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation


class Dreath {
    var amount: Float = 0
    
    func damage(amount: Float) {
        self.amount += -amount
        if self.amount < 0 {
            self.amount = 0
        }
    }
}

class DreathMap {
    var dreath: Dreath
    var grid: Grid
    var map: GameMap
    
    let threshold: Float = 2
    let clusterToSpawner: Float = 400
    
    init(_ game: Grid, _ map: GameMap) {
        dreath = Dreath()
        dreath.amount = 0
        self.grid = game
        self.map = map
    }
    
    func computeDreath(location: float2) -> Float {
        var amount = dreath.amount
        let dreaths = grid.actors.filter{ $0 is DreathActor }.map{ $0 as! DreathActor }
        dreaths.forEach { actor in
            let dreath = actor.dreath.amount
            let dl = location - actor.transform.location
            amount += (dreath) / dl.length
        }
        return amount / Float(dreaths.count)
    }
    
    func update() {
        spawn()
        spawnSpawner()
        spawnColony()
        spawnKnight()
    }
    
    func spawn() {
        let location = float2(random(0, Game.levelsize), -random(0, Camera.size.y))
        guard available(location) else { return }
        let local_dreath = computeDreath(location)
        if local_dreath >= threshold {
            grid.append(DreathFloater(location, local_dreath * 10 + 20, map, grid))
        }
    }
    
    private func available(location: float2) -> Bool {
        for actor in grid.actors {
            if actor.body.shape.getBounds().contains(location) {
                return false
            }
        }
        return true
    }
    
    private func spawnSpawner() {
        let clusters: [DreathCluster<DreathFloater>] = getClusters(0.5.m)
        for index in 0 ..< clusters.count {
            let cluster = clusters[index]
            if cluster.dreath >= clusterToSpawner {
                grid.append(DreathSpawner(cluster.floaters.first!.transform.location))
                play("make1")
                for floater in cluster.floaters {
                    floater.dreath.amount = 0
                }
            }
        }
    }
    
    private func spawnColony() {
        let spawners: [DreathCluster<DreathSpawner>] = getClusters(2.m)
        for cluster in spawners {
            if cluster.dreath >= 15000 {
                grid.append(DreathColony(cluster.floaters.first!.transform.location))
                for spw in cluster.floaters {
                    spw.dreath.amount = 0
                }
            }
        }
    }
    
    private func spawnKnight() {
        let colonies = grid.actors.filter{ $0 is DreathColony }.map{ $0 as! DreathColony }
        for colony in colonies {
            if colony.dreath.amount >= 7000 {
                colony.dreath.damage(1500)
                grid.append(DreathKnight(colony.transform.location + float2(0, -2.m), grid))
            }
        }
    }
    
    func getClusters<T where T: DreathActor>(distance: Float) -> [DreathCluster<T>] {
        var clusters: [DreathCluster<T>] = []
        let dreaths = grid.actors.filter{ $0 is T }.map{ $0 as! T }
        for i in 0 ..< dreaths.count {
            let prime = dreaths[i]
            let cluster = DreathCluster<T>()
            cluster.floaters.append(prime)
            clusters.append(cluster)
            for j in i + 1 ..< dreaths.count {
                let secunde = dreaths[j]
                if (prime.body.location - secunde.body.location).length <= distance{
                    cluster.floaters.append(secunde)
                }
            }
        }
        return clusters.filter{ $0.floaters.count > 1 }
    }
   
    func totalDreath() -> Float {
        var amount = dreath.amount
        grid.actors.forEach{
            if let dre = $0 as? DreathActor {
                amount += dre.dreath.amount
            }
        }
        return amount
    }
}

class DreathCluster<T: DreathActor> {
    var floaters: [T] = []
    
    var dreath: Float {
        var amount: Float = 0
        floaters.forEach{ amount += $0.dreath.amount }
        return amount
    }
}

class DreathActor: Character {
    var dreath: Dreath
    
    override init(_ location: float2, _ bounds: float2, _ substance: Substance, _ director: Director?) {
        dreath = Dreath()
        super.init(location, bounds, substance, director)
    }
}

class DreathFloater: DreathActor {
    
    init(_ location: float2, _ amount: Float, _ map: GameMap, _ game: Grid) {
        super.init(location, float2(0.1.m), Substance.StandardRotating(0.005, 0.001), FloaterDirector(map, game))
        //display.color = float4(0.3, 0.3, 0.3, 1)
        display.scheme.info.texture = GLTexture("Floater").id
        dreath.amount = amount
        setupBody()
    }
    
    private func setupBody() {
        body.relativeGravity = 0
        body.callback = { (body, _) in
            if let player = body.object as? Player {
                player.shield.damage(0.01)
            }
        }
    }
    
    override func update() {
        super.update()
        dreath.amount += 4 * Time.time
        let growth = dreath.amount / 100
        let clamped = clamp(growth, min: 0, max: 1)
        let value = 1 - clamped
        display.color = float4(value / 2, value * 0.4, 2 * growth - 0.2, 1)
        let rect = body.shape as! Rect
        rect.setBounds(float2(0.1.m) * (clamped))
        display.visual.refresh()
    }
    
}

class FloaterDirector: Director {
    let grid: Grid
    
    init(_ map: GameMap, _ game: Grid) {
        self.grid = game
        super.init(map)
    }
    
    override func update() {
        let player = map.player
        let dl = (player.transform.location) - actor.transform.location
        if dl.length <= 0.1.m {
            let direction = normalize(dl + player.body.velocity * 0.2)
            let mag = (20.m / dl.length + 10.m)
            var drag: Float = 300
            let separation = normalize(actor.body.velocity) - direction
            if separation.length >= 0.25 {
                drag = 50
            }
            actor.body.velocity += direction * mag / drag
        }
        actor.body.velocity += clusterForce()
        actor.body.velocity *= 0.95
    }
    
    private func clusterForce() -> float2 {
        var force = float2()
        
        let floaters = grid.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for floater in floaters where actor !== floater {
            let dl = floater.transform.location - actor.transform.location
            guard dl.length <= 4.m else { continue }
            let mag = (5.m) / dl.length
            let dir = normalize(dl)
            force += mag * dir
        }
        return force
    }
    
}

class DreathSpawner: DreathActor {
    
    init(_ location: float2) {
        super.init(location, float2(0.5.m), Substance.StandardRotating(2, 0.00001), nil)
        //display.color = float4(1, 0, 0.2, 1)
        display.scheme.info.texture = GLTexture("Spawner").id
        dreath.amount = 500
    }
    
    override func update() {
        super.update()
        dreath.amount += 100 * Time.time
        let growth = (dreath.amount) / 5000
        let clamped = clamp(growth, min: 0, max: 1)
        let value = 1 - growth
        display.color = float4(growth + 0.5, value * 0.9, value * 0.5, 1)
        let rect = body.shape as! Rect
        rect.setBounds(float2(1.5.m) * (clamped))
        display.visual.refresh()
        body.substance.mass.mass = 2 + growth * 4
    }
    
}

class DreathColony: DreathActor {
    
    init(_ location: float2) {
        super.init(location, float2(1.m, 2.m), Substance.getStandard(50), nil)
        display.color = float4(0.2, 0.2, 0.2, 1)
        display.scheme.info.texture = GLTexture("Colony").id
        dreath.amount = 5000
    }
    
    override func update() {
        super.update()
        dreath.amount += 100 * Time.time
        let growth = (dreath.amount) / 10000
        let clamped = clamp(growth, min: 0, max: 1)
        let value = 1 - growth
        display.color = float4(growth * 2, value, value * 0.2, 1)
        let rect = body.shape as! Rect
        rect.setBounds(float2(3.m, 3.m) * clamped)
        display.visual.refresh()
    }
    
}

class DreathKnight: DreathActor {
    let weapon: Weapon
    
    init(_ location: float2, _ grid: Grid) {
        weapon = Weapon(grid, "player", PlayerTargetter())
        super.init(location, float2(0.5.m, 1.m), Substance.getStandard(3), nil)
        display.color = float4(0.7, 0.7, 0.7, 1)
        dreath.amount = 500
        weapon.actor = self
        body.callback = { (body, collision) in
            if !self.onObject {
                self.onObject = collision.normal.y > 0
            }
        }
    }
    
    override func update() {
        super.update()
        let dl = Player.player.transform.location - transform.location
        if dl.length <= 15.m && dl.length >= 2.m {
            body.velocity.x += normalize(dl).x * 0.5.m
            if abs(body.velocity.x) > 2.m {
                body.velocity.x = 0
            }
            if random(0, 100) > 90 && onObject {
                body.velocity.y += -5.m
            }
        }
        weapon.fire()
    }
    
}













