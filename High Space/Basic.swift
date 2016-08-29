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
    
    init(_ hull: Hull, _ substance: Substance) {
        self.transform = hull.transform
        body = Body(hull, substance)
        super.init(Display(hull, GLTexture("white")))
    }
    
    func update() {}
}

class Structure: Actor {
    let rect: Rect
    
    init(_ location: float2, _ bounds: float2) {
        rect = Rect(location, bounds)
        super.init(rect, Substance.Solid)
        display.color = float4(0.11, 0.11, 0.12, 1)
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
    
    mutating func increase(amount: Float) {
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
        timer = Timer(1) {
            self.damaged = false
            play("shield-re1")
        }
    }
    
    func damage(amount: Float) {
        damaged = true
        timer.increment = 0
        points.increase(-amount)
    }
    
    func update() {
        if damaged {
            timer.update(Time.time)
        }else{
            points.increase(300 * Time.time)
        }
    }
}

class Player: Actor, Interface {
    static var player: Player!
    
    var shield: Shield
    var weapon: Weapon!
    var callback: String -> () = {_ in}
    
    init(_ location: float2, _ weapon: Weapon) {
        shield = Shield(amount: 1000)
        self.weapon = weapon
        super.init(Rect(location, float2(0.5.m, 1.m)), Substance.getStandard(3))
        weapon.actor = self
        body.object = self
        body.callback = { (body, collision) in
            if !self.onObject {
                self.onObject = collision.normal.y > 0
            }
            if let tag = body.tag {
                self.callback(tag)
            }
        }
        Player.player = self
    }
    
    func use(command: Command) {
        if command.id == 0 {
            body.velocity += command.vector! / 20
        }else if command.id == 1 {
            if (onObject) {
                body.velocity.y -= 750
                play("jump1")
            }
        }else if command.id == 2 {
            weapon.fire()
        }
    }
    
    override func update() {
        shield.update()
    }
    
}

class Weapon {
    let grid: Grid
    var actor: Actor!
    var count: Float
    var targetter: Targetter
    var tag: String
    
    init(_ grid: Grid, _ tag: String, _ targetter: Targetter) {
        self.grid = grid
        self.tag = tag
        self.targetter = targetter
        count = 0
    }
    
    func fire() {
        count += Time.time
        if count >= 0.2 {
            if let char = targetter.getTarget() {
                let location = char.transform.location
                let dl = location - actor.transform.location
                let bullet = Bullet(actor.transform.location + normalize(dl) * 0.25.m, tag)
                bullet.body.velocity = normalize(dl) * 5.m
                grid.append(bullet)
                play("shoot1")
            }
            count = 0
        }
    }
    
}

protocol Targetter {
    func getTarget() -> Actor?
}

class DreathTargetter: Targetter {
    unowned let grid: Grid
    var player: Player!
    
    init(_ grid: Grid) {
        self.grid = grid
    }
    
    func getTarget() -> Actor? {
        var bestactor: DreathActor?
        var length: Float = FLT_MAX
        var dreath: Float = 0
        
        for actor in grid.actors {
            if let char = actor as? DreathActor {
                let dl = player.transform.location - char.transform.location
                if length > dl.length && char.dreath.amount > dreath || char is DreathKnight {
                    length = dl.length
                    dreath = char.dreath.amount
                    bestactor = char
                }
            }
        }
        
        return bestactor
    }
}

class PlayerTargetter: Targetter {
    
    func getTarget() -> Actor? {
        return Player.player
    }
    
}

class Bullet: Actor {
    var active = true
    
    init(_ location: float2, _ tag: String) {
        super.init(Rect(location, float2(0.05.m, 0.05.m)), Substance.getStandard(0.01))
        body.relativeGravity = 0
        body.callback = { (body, _) in
            if tag == "dreath" {
                if let char = body.object as? DreathActor {
                    char.dreath.damage(200)
                    play("hit1")
                }
                if !(body.object is Player) {
                    self.active = false
                }
            }
            if tag == "player" {
                if let pla = body.object as? Player {
                    pla.shield.damage(5)
                    play("hit1")
                }
                if !(body.object is DreathActor) {
                    self.active = false
                }
            }
        }
    }
    
}

class Character: Actor {
    var director: Director?
    var status: Status
    
    init(_ location: float2, _ bounds: float2, _ substance: Substance, _ director: Director?) {
        self.director = director
        status = Status(100)
        super.init(Rect(location, bounds), substance)
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
    let map: GameMap
    
    init(_ map: GameMap) {
        self.map = map
    }
    
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