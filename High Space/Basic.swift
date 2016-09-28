//
//  Basic.swift
//  Sky's Melody
//
//  Created by Chris Luttio on 8/7/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

class Basic {
    let display: Display
    
    init(_ display: Display) {
        self.display = display
    }
}

class Actor: Basic {
    let transform: Transform
    let body: Body
    var onObject = false
    var alive = true
    var order = 0
    
    init(_ hull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        body = Body(hull, substance)
        super.init(Display(hull, GLTexture("white")))
    }
    
    func update() {}
    
    func render() {
        display.render()
    }
}

class Structure: Actor {
    let rect: Rect
    
    init(_ location: float2, _ bounds: float2) {
        rect = Rect(location, bounds)
        super.init(rect, Substance.Solid)
        display.color = float4(0.11, 0.11, 0.12, 1)
        body.mask = Int.max
        body.object = self
    }
    
}

class Door: Structure {
    var room: Int
    var direction: Int
    
    init(_ location: float2, _ bounds: float2, _ direction: Int) {
        room = -1
        self.direction = direction
        super.init(location, bounds)
        body.hidden = true
        display.color = float4(1, 1, 1, 0.5)
        display.texture = GLTexture("door").id
        if direction == -1 {
            display.scheme.layout.coordinates = display.scheme.layout.coordinates.rotate(2)
        }
    }
    
}

struct PointRange {
    var amount: Float
    var limit: Float
    
    init(_ limit: Float) {
        self.limit = limit
        amount = limit
    }
    
    var percent: Float {
        return amount / limit
    }
    
    mutating func increase(_ amount: Float) {
        self.amount += amount
        self.amount = clamp(self.amount, min: 0, max: limit)
    }
}

class Status {
    var hitpoints: PointRange
    
    init(_ limit: Float) {
        hitpoints = PointRange(limit)
    }
}

class Shield {
    var points: PointRange
    var damaged = false
    var timer: Timer!
    
    init(amount: Float) {
        points = PointRange(amount)
        timer = Timer(2) {
            self.damaged = false
            if self.points.percent <= 0.9 {
                play("shield-re1", 0.75)
            }
        }
    }
    
    func damage(_ amount: Float) {
        damaged = true
        timer.increment = 0
        points.increase(-amount)
        playIfNot("hit8", 0.65)
    }
    
    func update() {
        if damaged {
            timer.update(Time.time)
        }else{
            points.increase(500 * Time.time)
        }
    }
}

class ItemStack {
    var items: [Item]
    
    init() {
        items = []
    }
}

class Inventory {
    var items: [ItemStack]
    
    init() {
        items = []
        for _ in 0 ..< 12 {
            items.append(ItemStack())
        }
    }
    
    func append(_ item: Item) {
        guard let gem = item as? Gem else { return }
        if !insert(gem) {
            push(gem)
        }
    }
    
    private func insert(_ gem: Gem) -> Bool {
        for stack in items {
            if let g = stack.items.first as? Gem {
                if gem.identity == g.identity {
                    stack.items.append(gem)
                    return true
                }
            }
        }
        return false
    }
    
    private func push(_ item: Item) {
        for stack in items {
            if stack.items.isEmpty {
                stack.items.append(item)
                return
            }
        }
    }
}

class Score {
    static var pages: Int = 0
    static var inventory = Inventory()
}

class Player: Actor, Interface {
    static var player: Player!
    
    var shield: Shield
    var weapon: Weapon!
    var laser: Weapon!
    var callback: (String) -> () = {_ in}
    let spine: Skeleton
    var fuel: Float = 100
    
    var jumping = false
    var canSideJump = false
    var sideJumpNormal = float2()
    
    init(_ location: float2, _ weapon: Weapon) {
        shield = Shield(amount: 1000)
        self.weapon = weapon
        self.laser = Weapon(weapon.grid, "dreath", DreathHiveTargetter(weapon.grid), Weapon.Stats(50, 25, 0.5, 10, 1000))
        let transform = Transform(location)
        spine = Skeleton("spineboy", transform, float2(0, 0.4.m))
        super.init(Rect(transform, float2(0.4.m, 0.8.m)), Substance(Material(.wood), Mass(6, 0), Friction(.iron)))
        body.mask = 0b100001
        weapon.actor = self
        laser.actor = self
        body.object = self
        body.callback = { [unowned self] (body, collision) in
            if !self.onObject {
                self.onObject = collision.normal.y > FLT_EPSILON
                if body.substance.mass.mass == 0 {
                    self.canSideJump = true
                    self.sideJumpNormal = collision.normal
                }
                self.jumping = !self.onObject
            }
            if let tag = body.tag {
                if tag == "goal" {
                    if let actor = body.object as? Actor {
                        if actor.alive {
                            Score.pages += 1
                            play("pickup1")
                        }
                        actor.alive = false
                    }
                }
                if tag == "rock" {
                    if let actor = body.object as? Item {
                        if actor.alive {
                            Score.inventory.append(actor)
                            play("pickup2")
                        }
                        actor.alive = false
                    }
                }
            }
        }
        Player.player = self
        order = 100
    }
    
    func use(_ command: Command) {
        if command.id == 0 {
            let force = command.vector! / 10
            if abs(body.velocity.x) < 5.m {
                body.velocity.x += force.x
                spine.setDirection(force.x > 0 ? 1 : -1)
            }
        }else if command.id == 1 {
            if fuel > 0 {
                fuel -= 5
                body.velocity.y -= 0.75.m
                playIfNot("jet1", 1.5)
            }
            
        }else if command.id == 2 {
            weapon.fireVertex = spine.getBoneLocation("gunTip")
            weapon.fire()
        }else if command.id == 3 {
            laser.fireVertex = spine.getBoneLocation("gunTip")
            laser.fire()
        }
    }
    
    override func update() {
        shield.update()
        weapon.update()
        laser.update()
        
        fuel += 50 * Time.time
        
        if !jumping {
            if abs(body.velocity.x) > 0.2.m {
                spine.setAnimation("run")
            }else{
                spine.setAnimation("idle")
            }
        }else{
            spine.setAnimation("jump")
        }
        
        spine.update()
        
        if let target = weapon.targetter.getTarget() {
            let dl = target.transform.location - spine.getBoneLocation("gun")
            let angle = atan2(dl.y, dl.x)
            spine.rotateBone("gun", angle)
        }
        
        spine.updateWorld()
        
        canSideJump = false
    }
    
    override func render() {
        jumping = !onObject
        
        spine.render()
    }
}

class Weapon {
    
    struct Stats {
        var power: PointRange
        var cost: Float
        var firerate: Float
        var chargerate: Float
        var damage: Float
        
        init(_ limit: Float, _ cost: Float, _ rate: Float, _ charge: Float, _ damage: Float) {
            power = PointRange(limit)
            self.cost = cost
            self.firerate = rate
            self.chargerate = charge
            self.damage = damage
        }
    }
    
    let grid: Level
    var actor: Actor!
    var count: Float
    var targetter: Targetter
    var tag: String
    var fireVertex: float2?
    var stats: Stats
    
    init(_ grid: Level, _ tag: String, _ targetter: Targetter, _ stats: Stats) {
        self.grid = grid
        self.tag = tag
        self.targetter = targetter
        count = 0
        self.stats = stats
    }
    
    func fire() {
        count += Time.time
        if count >= stats.firerate && stats.power.amount >= stats.cost {
            if let target = targetter.getTarget() {
                shoot(target)
                stats.power.increase(-stats.cost)
            }
            count = 0
        }
    }
    
    func update() {
        stats.power.increase(stats.chargerate * Time.time)
    }
    
    private func shoot(_ target: Actor) {
        let ve = actor.transform.location
        let vert = fireVertex ?? ve
        let location = target.transform.location + target.body.velocity * Float(dt)
        let dl = location - vert
        let bullet = Bullet(vert, tag, stats.damage)
        bullet.body.orientation = atan2(dl.y, dl.x)
        bullet.body.velocity = normalize(dl) * 11.m
        grid.current.map.append(bullet)
        play("shoot2", random(0.8, 1.1))
    }
    
}

protocol Targetter {
    func getTarget() -> Actor?
}

class DreathTargetter: Targetter {
    unowned let grid: Level
    var player: Player!
    weak var target: DreathActor?
    
    init(_ grid: Level) {
        self.grid = grid
    }
    
    func getTarget() -> Actor? {
       
        var bestactor: DreathActor?
        var rating: Float = -FLT_MAX
        
        for actor in grid.current.map.actors {
            if let char = actor as? DreathActor {
                guard char.alive else { continue }
                let dl = player.transform.location - char.transform.location
                guard dl.length < 5.m else { continue }
                var lw = 10.m / dl.length * 2 //+ char.dreath.amount / 1000 * 0.5
                if char is DreathKnight {
                    lw += 10
                }
                if lw > rating {
                    rating = lw
                    bestactor = char
                }
            }
        }
        
        //target = bestactor
        return bestactor
    }
}

class DreathHiveTargetter: Targetter {
    unowned let grid: Level
    var player: Player!
    weak var target: DreathActor?
    
    init(_ grid: Level) {
        self.grid = grid
    }
    
    func getTarget() -> Actor? {
        
        var bestactor: DreathActor?
        var rating: Float = -FLT_MAX
        
        for actor in grid.current.map.actors {
            if let char = actor as? DreathActor {
                guard char.alive else { continue }
                let dl = Player.player.transform.location - char.transform.location
                guard dl.length < 5.m else { continue }
                var lw = 10.m / dl.length + char.dreath.amount
                if char is DreathKnight {
                    lw += 10
                }
                if lw > rating {
                    rating = lw
                    bestactor = char
                }
            }
        }
        
        //target = bestactor
        return bestactor
    }
}

class PlayerTargetter: Targetter {
    
    func getTarget() -> Actor? {
        return Player.player
    }
    
}

class Bullet: Actor {
    var damage: Float
    
    init(_ location: float2, _ tag: String, _ damage: Float) {
        self.damage = damage
        super.init(Rect(location, float2(0.25.m, 0.04.m)), Substance(Material(.wood), Mass(10, 0), Friction(.iron)))
        display.scheme.info.texture = GLTexture("bullet").id
        display.color = float4(0.4, 1, 0.4, 1)
        body.relativeGravity = 0
        body.mask = 0b01110
        body.callback = { [unowned self] (body, _) in
            if tag == "dreath" {
                if let char = body.object as? DreathActor {
                    char.dreath.damage(damage)
                    play("hit1", 1.5)
                }
                if !(body.object is Player) {
                    self.alive = false
                }
            }
            if tag == "player" {
                if let pla = body.object as? Player {
                    pla.shield.damage(5)
                    play("hit1")
                }
                if !(body.object is DreathActor) {
                    self.alive = false
                }
            }
            //self.alive = false
        }
    }
    
    override func update() {
        super.update()
    }
    
}

class Character: Actor {
    var director: Director?
    var status: Status
    
    init(_ hull: Hull, _ substance: Substance, _ director: Director?) {
        self.director = director
        status = Status(100)
        super.init(hull, substance)
        body.object = self
        director?.actor = self
    }
    
    override func update() {
        director?.update()
    }
}

class GameMap {
    var player: Player!
}

class Director {
    var actor: Actor!
    
    func update() {}
}

class RenderLayer {
    var displays: [Display]
    
    init() {
        displays = []
    }
    
    func render() {
        displays.filter{ Camera.distance($0.scheme.hull.transform.location) <= Camera.size.length + 2.m }.forEach{ $0.render() }
    }
}

class RenderMaster {
    var layers: [RenderLayer]
    
    init() {
        layers = []
    }
    
    func render() {
        layers.forEach{ $0.render() }
    }
}
