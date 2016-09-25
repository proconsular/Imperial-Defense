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
    
    func damage(_ amount: Float) {
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
    var grid: Level
   
    let threshold: Float = 1.25
    let clusterToSpawner: Float = 400
    var dreaths: [DreathActor]
    
    var dreathcreators: [DreathCreator]
    
    init(_ game: Level) {
        dreath = Dreath(0, 0)
        self.grid = game
        dreaths = []
        dreathcreators = []
        dreathcreators.append(FloaterCreator(self, 1))
        dreathcreators.append(ClusterCreator(self, 0))
        dreathcreators.append(SpawnerCreator(self, 10))
        dreathcreators.append(ColonyCreator(self, 0))
        //dreathcreators.append(KnightCreator(self))
    }
    
    func computeDreath(_ location: float2) -> Float {
        var amount = dreath.value
        let dreaths = grid.current.map.actors.filter{ $0 is DreathActor }.map{ $0 as! DreathActor }
        dreaths.forEach { actor in
            let dreath = actor.dreath.value
            let dl = location - actor.transform.location
            amount += (dreath) / dl.length
        }
        return amount / Float(dreaths.count)
    }
    
    func update() {
        dreaths = grid.current.map.actors.filter{ $0 is DreathActor }.map{ $0 as! DreathActor }
        dreathcreators.forEach{
            if let dreath = $0.create() {
                append(dreath)
            }
        }
        dreaths.removeAll()
    }
    
    func spawn(_ amount: Float) {
        var count = amount
        while count > 0 {
            dreathcreators.forEach{
                if let dreath = $0.spawn() {
                    if count >= $0.cost {
                        append(dreath)
                        count -= $0.cost
                    }
                }
            }
        }
    }
    
    fileprivate func append(_ dreath: DreathActor) {
        grid.current.map.append(dreath)
    }
    
    func available(_ location: float2) -> Bool {
        for actor in grid.current.map.actors {
            if actor.body.shape.getBounds().contains(location) {
                return false
            }
        }
        return true
    }
    
    func totalDreath() -> Float {
        var amount = dreath.value
        grid.current.map.actors.forEach{
            if let dre = $0 as? DreathActor {
                amount += dre.dreath.value
            }
        }
        return amount
    }
}

class DreathCreator {
    let dreathmap: DreathMap
    let cost: Float
    
    init(_ map: DreathMap, _ cost: Float) {
        self.dreathmap = map
        self.cost = cost
    }
    
    func create() -> DreathActor? {
        return nil
    }
    
    func spawn() -> DreathActor? {
        return nil
    }
    
    func getAvailableLocation() -> float2? {
        let location = float2(random(0, dreathmap.grid.current.map.size.x), -random(0, dreathmap.grid.current.map.size.y))
        guard dreathmap.available(location) else { return nil }
        return location
    }
}

class FloaterCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        guard let location = getAvailableLocation() else { return nil }
        let local_dreath = dreathmap.computeDreath(location)
        guard local_dreath >= dreathmap.threshold else { return nil }
        return DreathFloater(location, local_dreath * 10 + 20, dreathmap.grid)
    }
    
    override func spawn() -> DreathActor? {
        guard let location = getAvailableLocation() else { return nil }
        return DreathFloater(location, 30, dreathmap.grid)
    }
    
}

class ClusterCreator: DreathCreator {
    
    override func create() -> DreathActor? {
        let dre = dreathmap.dreaths
        let list = dre.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
        for floater in list {
            if floater.cluster == nil {
                if floater.dreath.value >= 150 {
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
            if let cluster = floater.cluster , cluster.alive {
                if cluster.amount >= 5000 {
                    let center = cluster.center
                    cluster.destroy()
                    return DreathSpawner(center)
                }
            }
        }
        return nil
    }
    
    override func spawn() -> DreathActor? {
        guard let location = getAvailableLocation() else { return nil }
        return DreathSpawner(location)
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
    
    func append(_ floater: DreathFloater) {
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
        attack()
        floaters = floaters.filter{ $0.alive }
        alive = floaters.count > 0
    }
    
    func attack() {
        let dl = Player.player.transform.location - center
        if dl.length <= 5.m {
            let dir = normalize(dl)
            let mag = 6.m * Time.time
            move(mag * dir)
        }
    }
    
    func move(_ force: float2) {
        floaters.forEach{ $0.body.velocity += force }
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
    
    fileprivate func grow(_ growth: Float) {
        display.color = computeColor(growth)
        
        let rect = body.shape as! Circle
        rect.setRadius(computeRadius(growth))
        
        display.visual.refresh()
    }
    
    fileprivate func computeGrowth(_ scale: Float) -> Float {
        return clamp(dreath.value / scale, min: 0, max: 1)
    }
    
    func computeColor(_ value: Float) -> float4 {
        return float4(value, value, value, 1)
    }
    
    func computeRadius(_ value: Float) -> Float {
        return 1.m * value
    }
}

class DreathFloater: DreathActor {
    weak var cluster: DreathFloaterCluster?
    var unique: float4
    
    init(_ location: float2, _ amount: Float, _ game: Level) {
        unique = float4(random(0, 0.4), random(0, 0.4), random(0, 0.4), 1)
        super.init(Circle(Transform(location), 0.1.m), Substance(Material(.rock), Mass(0.5, 0), Friction(.ice)), FloaterDirector(game))
        display.scheme.info.texture = GLTexture("Floater").id
        dreath = Dreath(amount, 20)
        setupBody()
    }
    
    fileprivate func setupBody() {
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
    
    override func computeColor(_ value: Float) -> float4 {
        return float4(value / 2, value / 2, value / 2, 1) * unique
    }
    
    override func computeRadius(_ value: Float) -> Float {
        return 0.03.m * value
    }
}

class FloaterDirector: Director {
    let grid: Level
    var attackTimer: Float = 0
    var attackingTimer: Float = 0
    var mode = 0
    
    init(_ game: Level) {
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
    
    fileprivate func attackPlayer() {
        let player = Player.player
        let dl = (player?.transform.location)! - actor.transform.location
        if dl.length <= 5.m && mode != 1 {
            attackTimer += Time.time
            if attackTimer >= 1 {
                attackTimer = 0
                mode = 1
                play("charge2", 2)
                attack(dl, 30)
            }
        }
    }
    
    fileprivate func attackmode() {
        let player = Player.player
        let dl = (player?.transform.location)! - actor.transform.location
        
        attackingTimer += Time.time
        if attackingTimer <= 8 {
            if dl.length <= 10.m {
                attack(dl)
            }else{
                mode = 0
                attackingTimer = 0
            }
        }else{
            mode = 0
            attackingTimer = 0
        }
    }
    
    fileprivate func attack(_ dl: float2, _ speed: Float = 1) {
        let direction = normalize(dl)
        let power = 6.m * speed * Time.time
        actor.body.velocity += power * direction
    }
    
    fileprivate func clusterForce() {
        if let floater = actor as? DreathFloater {
            if floater.cluster == nil {
                let floaters = grid.current.map.actors.filter{ $0 is DreathFloater }.map{ $0 as! DreathFloater }
                for floater in floaters where actor !== floater {
                    if let cluster = floater.cluster {
                        if cluster.floaters.count <= 12 {
                            actor.body.velocity += movetoCluster(cluster)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func cluster() {
        guard let floater = actor as? DreathFloater else { return }
        guard let clust = floater.cluster else { return }
        let dl = clust.center - floater.transform.location
        if dl.length != 0 {
            let mag = 15.m * Time.time
            let dir = normalize(dl)
            actor.body.velocity += mag * dir
        }
    }
    
    fileprivate func movetoCluster(_ cluster: DreathFloaterCluster) -> float2 {
        let dl = cluster.center - actor.transform.location
        guard dl.length <= 4.m else { return float2() }
        let mag = 10.m * Time.time
        let dir = normalize(dl)
        if dl.length <= 1.m {
            cluster.append(actor as! DreathFloater)
            mode = 2
        }
        return mag * dir
    }
    
}

class DreathSpawner: DreathActor {
    
    init(_ location: float2) {
        super.init(Circle(Transform(location), 0.5.m), Substance.StandardRotating(10, 0.000001), nil)
        body.substance.friction = Friction(.iron)
        //display.color = float4(1, 0, 0.2, 1)
        display.scheme.info.texture = GLTexture("Spawner").id
        dreath = Dreath(1000, 250)
    }
    
    override func update() {
        super.update()
        dreath.update()
        let growth = computeGrowth(5000)
        
        grow(growth)
        
        body.substance.mass.mass = 8 + growth * 10
    }
    
    override func computeColor(_ value: Float) -> float4 {
        let inverse = 1 - value
        return float4(value + 0.5, inverse * 0.9, inverse * 0.5, 1)
    }
    
    override func computeRadius(_ value: Float) -> Float {
        return 0.75.m * value
    }
    
}

class DreathColony: DreathActor {
    
    init(_ location: float2) {
        super.init(Circle(Transform(location), 1.m), Substance.StandardRotating(50, 0.0000001), nil)
        display.color = float4(0.2, 0.2, 0.2, 1)
        display.scheme.info.texture = GLTexture("Colony").id
        dreath = Dreath(5000, 300)
        body.mask = 0b01000
        order = -1
    }
    
    override func update() {
        super.update()
        dreath.update()
        grow(computeGrowth(10000))
    }
    
    override func computeColor(_ value: Float) -> float4 {
        return float4(value * 2, 0.3, value / 2, 1)
    }
    
    override func computeRadius(_ value: Float) -> Float {
        return 1.5.m * value
    }
    
}

class DreathKnight: DreathActor {
    let weapon: Weapon
    
    init(_ location: float2, _ grid: Level) {
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













