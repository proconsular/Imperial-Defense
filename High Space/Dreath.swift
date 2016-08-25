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
            amount += dreath / dl.length
        }
        return amount / Float(dreaths.count)
    }
    
    func update() {
        spawn()
        spawnSpawner()
    }
    
    func spawn() {
        let location = float2(random(0, 100.m), -random(0, Camera.size.y))
        guard available(location) else { return }
        let local_dreath = computeDreath(location)
        if local_dreath >= 0.25 {
            grid.append(DreathFloater(location, map, grid))
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
        let clusters = getClusters()
        for index in 0 ..< clusters.count {
            let cluster = clusters[index]
            if cluster.dreath >= 500 {
                grid.append(DreathSpawner(cluster.floaters.first!.transform.location))
                for floater in cluster.floaters {
                    floater.dreath.amount = 0
                }
            }
        }
    }
    
    func getClusters() -> [DreathCluster] {
        var clusters: [DreathCluster] = []
        let dreaths = grid.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for i in 0 ..< dreaths.count {
            let prime = dreaths[i]
            let cluster = DreathCluster()
            cluster.floaters.append(prime)
            clusters.append(cluster)
            for j in i + 1 ..< dreaths.count {
                let secunde = dreaths[j]
                if (prime.body.location - secunde.body.location).length <= 0.5.m {
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

class DreathCluster {
    var floaters: [DreathFloater] = []
    
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
    
    init(_ location: float2, _ map: GameMap, _ game: Grid) {
        super.init(location, float2(0.1.m), Substance.getStandard(0.005), FloaterDirector(map, game))
        display.color = float4(0.3, 0.3, 0.3, 1)
        dreath.amount = 25
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
        let value = 0.7 - clamped
        display.color = float4(value, value, value, 1)
        let rect = body.shape as! Rect
        rect.setBounds(float2(0.15.m) * (clamped))
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
            guard dl.length <= 5.m else { continue }
            let mag = 10.m / dl.length
            let dir = normalize(dl)
            force += mag * dir
        }
        return force
    }
    
}

class DreathSpawner: DreathActor {
    
    init(_ location: float2) {
        super.init(location, float2(0.5.m), Substance.getStandard(5), nil)
        display.color = float4(1, 0, 0.2, 1)
        dreath.amount = 500
    }
    
    override func update() {
        super.update()
        dreath.amount += 100 * Time.time
        let growth = (dreath.amount) / 2000
        let clamped = clamp(growth, min: 0, max: 1)
        let value = 1 - clamped
        display.color = float4(value * 0.7, 0.1, value * 0.1, 1)
        let rect = body.shape as! Rect
        rect.setBounds(float2(1.m) * (clamped))
        display.visual.refresh()
    }
    
}