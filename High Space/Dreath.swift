//
//  Dreath.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/18/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation


class Dreath {
    let base: Float
    let rate: Float
    var amount: Float
    
    init(_ base: Float, _ rate: Float) {
        self.base = base
        self.rate = rate
        amount = 0
    }
    
    func damage(amount: Float) {
        self.amount += -amount
        if value < 0 {
            self.amount = -base
        }
    }
    
    func update() {
        amount += rate * Time.time
    }
    
    var value: Float {
        return base + amount
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
        dreath = Dreath(0, 0)
        self.grid = game
        dreaths = []
        dreathcreators = []
        dreathcreators.append(FloaterCreator(self))
        dreathcreators.append(ClusterCreator(self))
        dreathcreators.append(SpawnerCreator(self))
        dreathcreators.append(ColonyCreator(self))
        //dreathcreators.append(KnightCreator(self))
    }
    
    func computeDreath(location: float2) -> Float {
        var amount = dreath.amount
        let dreaths = grid.actors.filter{ $0 is DreathActor }.map{ $0 as! DreathActor }
        dreaths.forEach { actor in
            let dreath = actor.dreath.value
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
        dreaths.removeAll()
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
        var amount = dreath.value
        grid.actors.forEach{
            if let dre = $0 as? DreathActor {
                amount += dre.dreath.value
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
                if floater.dreath.value >= 250 {
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
            if let cluster = floater.cluster where cluster.alive {
                if cluster.amount >= 750 {
                    let center = cluster.center
                    cluster.destroy()
                    return DreathSpawner(center)
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
            if spawner.dreath.value >= 5000 {
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
            if colony.dreath.value >= 7000 {
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
        height = random(2.m, 3.m)
        super.init(Rect(float2(), float2()), Substance.getStandard(0), nil)
        body.relativeGravity = 0
        body.hidden = true
        dreath = Dreath(1, 0)
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
        floaters.forEach{ amount += $0.dreath.value }
        return amount
    }
    
    override func update() {
        super.update()
        transform.location = center
//        let dy = float2(center.x, -height) - center
//        let mag = 0.01.m
//        let dir = normalize_safe(dy) ?? float2()
//        floaters.forEach{ $0.body.velocity += mag * dir }
        floaters = floaters.filter{ $0.alive }
        alive = floaters.count > 0
    }
    
    func destroy() {
        alive = false
        floaters.forEach{ $0.alive = false }
        floaters.removeAll()
    }
}

class DreathActor: Character {
    var dreath: Dreath!
    
    override init(_ hull: Hull, _ substance: Substance, _ director: Director?) {
        super.init(hull, substance, director)
        body.mask |= 0b010
    }
    
    override func update() {
        super.update()
        if dreath.amount <= -dreath.base * 0.1 {
            alive = false
        }
    }
    
    private func grow(growth: Float) {
        display.color = computeColor(growth)
        
        let rect = body.shape as! Circle
        rect.setRadius(computeRadius(growth))
        
        display.visual.refresh()
    }
    
    private func computeGrowth(scale: Float) -> Float {
        return clamp(dreath.value / scale, min: 0, max: 1)
    }
    
    func computeColor(value: Float) -> float4 {
        return float4(value, value, value, 1)
    }
    
    func computeRadius(value: Float) -> Float {
        return 1.m * value
    }
}

class DreathFloater: DreathActor {
    weak var cluster: DreathFloaterCluster?
    var unique: float4
    
    init(_ location: float2, _ amount: Float, _ game: Grid) {
        unique = float4(random(0, 0.4), random(0, 0.4), random(0, 0.4), 1)
        super.init(Circle(Transform(location), 0.1.m), Substance(Material(.BouncyBall), Mass(0.1, 0.0005), Friction(.Iron)), FloaterDirector(game))
        display.scheme.info.texture = GLTexture("Floater").id
        dreath = Dreath(amount, 10)
        setupBody()
    }
    
    private func setupBody() {
        body.relativeGravity = 0
        body.callback = { (body, _) in
            if let player = body.object as? Player {
                player.shield.damage(1)
            }
        }
    }
    
    override func update() {
        super.update()
        dreath.update()
        grow(computeGrowth(100))
    }
    
    override func computeColor(value: Float) -> float4 {
        return float4(value / 2, value / 2, value / 2, 1) * unique
    }
    
    override func computeRadius(value: Float) -> Float {
        return 0.03.m * value
    }
}

class FloaterDirector: Director {
    let grid: Grid
    var attackTimer: Float = 0
    var attackingTimer: Float = 0
    var mode = 0
    
    init(_ game: Grid) {
        self.grid = game
        super.init()
    }
    
    override func update() {
        let floater = actor as! DreathFloater
        clusterForce()
        if floater.cluster != nil {
            cluster()
        }else{
            attackPlayer()
            attackmode()
        }
        actor.body.velocity *= 0.95
    }
    
    private func attackPlayer() {
        let player = Player.player
        let dl = player.transform.location - actor.transform.location
        if dl.length <= 5.m && mode != 1 {
            attackTimer += Time.time
            if attackTimer >= 1 {
                attackTimer = 0
                mode = 1
                play("charge2", 1.5)
                attack(dl, 30)
            }
        }
    }
    
    private func attackmode() {
        let player = Player.player
        let dl = player.transform.location - actor.transform.location
        
        attackingTimer += Time.time
        if attackingTimer <= 8 {
            attack(dl)
        }else{
            mode = 0
            attackingTimer = 0
        }
    }
    
    private func attack(dl: float2, _ speed: Float = 1) {
        let direction = normalize(dl)
        let power = 6.m * speed * Time.time
        actor.body.velocity += power * direction
    }
    
    private func clusterForce() {
        if let floater = actor as? DreathFloater {
            if floater.cluster == nil {
                let floaters = grid.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
                for floater in floaters where actor !== floater {
                    if let cluster = floater.cluster {
                        if cluster.floaters.count <= 4 {
                            actor.body.velocity += movetoCluster(cluster)
                            mode = 2
                        }
                    }
                }
            }
        }
    }
    
    private func cluster() {
        guard let floater = actor as? DreathFloater else { return }
        guard let clust = floater.cluster else { return }
        let dl = clust.center - floater.transform.location
        if dl.length != 0 {
            let mag = 0.05.m * dl.length * Time.time
            let dir = normalize(dl)
            actor.body.velocity += mag * dir
        }
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
        super.init(Circle(Transform(location), 0.5.m), Substance.StandardRotating(10, 0.00001), nil)
        body.substance.friction = Friction(.Iron)
        //display.color = float4(1, 0, 0.2, 1)
        display.scheme.info.texture = GLTexture("Spawner").id
        dreath = Dreath(1000, 100)
    }
    
    override func update() {
        super.update()
        dreath.update()
        let growth = computeGrowth(5000)
        
        grow(growth)
        
        body.substance.mass.mass = 8 + growth * 10
    }
    
    override func computeColor(value: Float) -> float4 {
        let inverse = 1 - value
        return float4(value + 0.5, inverse * 0.9, inverse * 0.5, 1)
    }
    
    override func computeRadius(value: Float) -> Float {
        return 0.75.m * value
    }
    
}

class DreathColony: DreathActor {
    
    init(_ location: float2) {
        super.init(Circle(Transform(location), 1.m), Substance.getStandard(50), nil)
        display.color = float4(0.2, 0.2, 0.2, 1)
        display.scheme.info.texture = GLTexture("Colony").id
        dreath = Dreath(5000, 100)
        body.mask = 0b01000
        order = -1
    }
    
    override func update() {
        super.update()
        dreath.update()
        grow(computeGrowth(10000))
    }
    
    override func computeColor(value: Float) -> float4 {
        return float4(value * 2, 0.3, value / 2, 1)
    }
    
    override func computeRadius(value: Float) -> Float {
        return 1.5.m * value
    }
    
}

class DreathKnight: DreathActor {
    let weapon: Weapon
    
    init(_ location: float2, _ grid: Grid) {
        weapon = Weapon(grid, "player", PlayerTargetter(), Weapon.Stats(0, 0, 0, 0, 0))
        super.init(Rect(location, float2(0.5.m, 1.m)), Substance.getStandard(3), nil)
        display.color = float4(0.7, 0.7, 0.7, 1)
        body.mask = 1 | 1 << 2
        dreath = Dreath(500, 0)
        weapon.actor = self
        body.callback = { [unowned self] (body, collision) in
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













