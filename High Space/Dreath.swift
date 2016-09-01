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
   
    let threshold: Float = 2
    let clusterToSpawner: Float = 400
    var dreaths: [DreathActor]
    
    var dreathcreators: [DreathCreator]
    
    init(_ game: Grid) {
        dreath = Dreath()
        dreath.amount = 0
        self.grid = game
        dreaths = []
        dreathcreators = []
        dreathcreators.append(FloaterCreator(self))
        dreathcreators.append(ClusterCreator(self))
        dreathcreators.append(SpawnerCreator(self))
        dreathcreators.append(ColonyCreator(self))
        dreathcreators.append(KnightCreator(self))
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
        dreaths = grid.actors.filter{ $0 is DreathActor }.map{ $0 as! DreathActor }
        dreathcreators.forEach{
            if let dreath = $0.create() {
                append(dreath)
            }
        }
    }
    
    private func append(dreath: DreathActor) {
        grid.append(dreath)
    }
    
    func available(location: float2) -> Bool {
        for actor in grid.actors {
            if actor.body.shape.getBounds().contains(location) {
                return false
            }
        }
        return true
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

class DreathCreator {
    let dreathmap: DreathMap
    
    init(_ map: DreathMap) {
        self.dreathmap = map
    }
    
    func create() -> DreathActor? {
        return nil
    }
}

class FloaterCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        let location = float2(random(0, Game.levelsize), -random(0, Camera.size.y))
        guard dreathmap.available(location) else { return nil }
        let local_dreath = dreathmap.computeDreath(location)
        if local_dreath >= dreathmap.threshold {
            return DreathFloater(location, local_dreath * 10 + 20, dreathmap.grid)
        }
        return nil
    }
    
}

class ClusterCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        let dre = dreathmap.dreaths
        let list = dre.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for floater in list {
            if floater.cluster == nil {
                if floater.dreath.amount >= 100 {
                    let cluster = DreathFloaterCluster()
                    cluster.append(floater)
                    return cluster
                }
            }
        }
        return nil
    }
    
}

class SpawnerCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        let dre = dreathmap.dreaths
        let list = dre.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for floater in list {
            if let cluster = floater.cluster {
                if cluster.amount >= 500 {
                    cluster.destroy()
                    return DreathSpawner(cluster.center)
                }
            }
        }
        return nil
    }
    
}

class ColonyCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        let dre = dreathmap.dreaths
        let list = dre.filter{ $0 is DreathSpawner }.map{ $0 as! DreathSpawner }
        for spawner in list {
            if spawner.dreath.amount >= 5000 {
                spawner.dreath.amount = 0
                return DreathColony(spawner.transform.location)
            }
        }
        return nil
    }
    
}

class KnightCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        let dre = dreathmap.dreaths
        let colonies = dre.filter{ $0 is DreathColony }.map{ $0 as! DreathColony }
        for colony in colonies {
            if colony.dreath.amount >= 7000 {
                colony.dreath.damage(1500)
                return DreathKnight(colony.transform.location + float2(0, -2.m), dreathmap.grid)
            }
        }
        return nil
    }
    
}

class DreathFloaterCluster: DreathActor {
    var floaters: [DreathFloater]
    let height: Float
    
    init() {
        floaters = []
        height = random(3.m, 4.m)
        super.init(float2(), float2(), Substance.getStandard(0), nil)
        dreath.amount = 1
    }
    
    func append(floater: DreathFloater) {
        floater.cluster = self
        floaters.append(floater)
    }
    
    var center: float2 {
        var vertex = float2()
        for floater in floaters {
            vertex += floater.transform.location
        }
        return vertex / Float(floaters.count)
    }
    
    var amount: Float {
        var amount: Float = 0
        floaters.forEach{ amount += $0.dreath.amount }
        return amount
    }
    
    override func update() {
        let dy = float2(center.x, -height) - center
        let mag = 0.01.m
        let dir = normalize_safe(dy) ?? float2()
        floaters.forEach{ $0.body.velocity += mag * dir }
    }
    
    func destroy() {
        dreath.amount = 0
        floaters.forEach{ $0.dreath.amount = 0 }
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
    var cluster: DreathFloaterCluster?
    
    init(_ location: float2, _ amount: Float, _ game: Grid) {
        super.init(location, float2(0.1.m), Substance.StandardRotating(0.005, 0.001), FloaterDirector(game))
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
    
    init(_ game: Grid) {
        self.grid = game
        super.init()
    }
    
    override func update() {
        let player = Player.player
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
        
        if let floater = actor as? DreathFloater {
            if floater.cluster == nil {
                let floaters = grid.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
                for floater in floaters where actor !== floater {
                    if let cluster = floater.cluster {
                        if cluster.floaters.count <= 4 {
                            force += movetoCluster(cluster)
                        }
                    }
                }
            }else{
                let dl = floater.cluster!.center - floater.transform.location
                if dl.length != 0 {
                    let mag = dl.length / 4
                    let dir = normalize(dl)
                    force += mag * dir
                }
            }
        }
        
        return force
    }
    
    private func movetoCluster(cluster: DreathFloaterCluster) -> float2 {
        let dl = cluster.center - actor.transform.location
        guard dl.length <= 4.m else { return float2() }
        let mag = (5.m) / dl.length
        let dir = normalize(dl)
        if dl.length <= 1.m {
            cluster.append(actor as! DreathFloater)
        }
        return mag * dir
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













