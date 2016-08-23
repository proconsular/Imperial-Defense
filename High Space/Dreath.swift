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
}

class DreathMap {
    var dreath: Dreath
    var game: GameController
    
    init(_ game: GameController) {
        dreath = Dreath()
        dreath.amount = 1
        self.game = game
    }
    
    func computeDreath(location: float2) -> Float {
        var amount = dreath.amount
        let dreaths = game.actors.filter{ $0 is DreathActor }.map{ $0 as! DreathActor }
        dreaths.forEach { actor in
            let dreath = actor.dreath.amount
            let dl = location - actor.transform.location
            amount += dreath / dl.length
        }
        return amount / Float(dreaths.count)
    }
    
    func update() {
        Int(rand() % 3).cycle {
            spawn()
        }
        spawnSpawner()
    }
    
    func spawn() {
        let location = float2(random(0, 100.m), -random(0, Camera.size.y))
        guard available(location) else { return }
        let local_dreath = computeDreath(location)
        if local_dreath >= 0.6 {
            game.append(DreathFloater(location, game.map, game))
        }
    }
    
    private func available(location: float2) -> Bool {
        for actor in game.actors {
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
            if cluster.floaters.count >= 6 {
                game.append(DreathSpawner(cluster.floaters.first!.transform.location))
                for floater in cluster.floaters {
                    floater.status.hitpoints.amount = 0
                }
            }
        }
    }
    
    func getClusters() -> [DreathCluster] {
        var clusters: [DreathCluster] = []
        let dreaths = game.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for i in 0 ..< dreaths.count {
            let prime = dreaths[i]
            let cluster = DreathCluster()
            cluster.floaters.append(prime)
            clusters.append(cluster)
            for j in i + 1 ..< dreaths.count {
                let secunde = dreaths[j]
                if (prime.body.location - secunde.body.location).length <= 1.m {
                    cluster.floaters.append(secunde)
                }
            }
        }
        return clusters.filter{ $0.floaters.count > 1 }
    }
}

class DreathCluster {
    var floaters: [DreathFloater] = []
}

class DreathActor: Character {
    var dreath: Dreath
    
    override init(_ location: float2, _ bounds: float2, _ substance: Substance, _ director: Director?) {
        dreath = Dreath()
        super.init(location, bounds, substance, director)
    }
}

class DreathFloater: DreathActor {
    
    init(_ location: float2, _ map: GameMap, _ game: GameController) {
        super.init(location, float2(0.1.m), Substance.getStandard(0.02), FloaterDirector(map, game))
        status = Status(20)
        display.color = float4(0.3, 0.3, 0.3, 1)
        dreath.amount = 25
        setupBody()
    }
    
    private func setupBody() {
        body.relativeGravity = 0
        body.callback = { (body, _) in
            if let player = body.object as? Player {
                player.shield.damage(0.25)
            }
        }
    }
    
}

class FloaterDirector: Director {
    let game: GameController
    
    init(_ map: GameMap, _ game: GameController) {
        self.game = game
        super.init(map)
    }
    
    override func update() {
        let player = map.player
        let dl = (player.transform.location) - actor.transform.location
        guard dl.length <= 20.m else { return }
        let direction = normalize(dl + player.body.velocity * 0.2)
        let mag = (20.m / dl.length + 10.m)
        var drag: Float = 300
        let separation = normalize(actor.body.velocity) - direction
        if separation.length >= 0.25 {
            drag = 50
        }
        let clustering = clusterForce()
        actor.body.velocity += direction * mag / drag + clustering
    }
    
    private func clusterForce() -> float2 {
        var force = float2()
        let floaters = game.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for floater in floaters where actor !== floater {
            let dl = floater.transform.location - actor.transform.location
            let mag = 50.m / dl.length
            let dir = normalize(dl)
            force += mag * dir
        }
        return force
    }
    
}

class DreathSpawner: DreathActor {
    
    init(_ location: float2) {
        super.init(location, float2(0.5.m), Substance.getStandard(3), nil)
        status = Status(30)
        display.color = float4(1, 0, 0.2, 1)
        dreath.amount = 500
    }
    
}