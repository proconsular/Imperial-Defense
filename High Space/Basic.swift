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

class Player: Actor, Interface {
    var status: Status
    var weapon: Weapon!
    var callback: String -> () = {_ in}
    
    init(_ location: float2, _ weapon: Weapon) {
        status = Status(100)
        self.weapon = weapon
        super.init(Rect(location, float2(0.5.m, 1.m)), Substance.getStandard(0.3))
        weapon.player = self
        body.object = self
        body.callback = { (body, collision) in
            if !self.onObject {
                self.onObject = collision.normal.y > 0
            }
            if let tag = body.tag {
                self.callback(tag)
            }
        }
    }
    
    func use(command: Command) {
        if command.id == 0 {
            body.velocity += command.vector! / 20
        }else if command.id == 1 {
            if (onObject) {
                body.velocity.y -= 750
            }
        }else if command.id == 2 {
            weapon.fire()
        }
    }
}

class Weapon {
    let controller: GameController
    var player: Player!
    var count: Float
    
    init(_ controller: GameController) {
        self.controller = controller
        count = 0
    }
    
    func fire() {
        count += Time.time
        if count >= 0.2 {
            if let char = findActor() {
                let location = char.transform.location
                let dl = location - player.transform.location
                let bullet = Bullet(player.transform.location + normalize(dl) * 0.25.m)
                bullet.body.velocity = normalize(dl) * 10.m
                controller.append(bullet)
            }
            count = 0
        }
    }
    
    func findActor() -> Actor? {
        var bestactor: Actor?
        var length: Float = FLT_MAX
        
        for actor in controller.actors {
            if let char = actor as? Character {
                let dl = player.transform.location - char.transform.location
                if length > dl.length {
                    length = dl.length
                    bestactor = actor
                }
            }
        }
        
        return bestactor
    }
    
}

class Bullet: Actor {
    var active = true
    
    init(_ location: float2) {
        super.init(Rect(location, float2(0.05.m, 0.05.m)), Substance.getStandard(0.5))
        body.relativeGravity = 0
        body.callback = { (body, _) in
            if let char = body.object as? Character {
                char.status.hitpoints.increase(-5)
                self.active = false
            }
        }
    }
    
}

class Character: Actor {
    var director: Director
    var status: Status
    
    init(_ location: float2, _ bounds: float2, _ director: Director) {
        self.director = director
        status = Status(20)
        super.init(Rect(location, bounds), Substance.getStandard(0.01))
        body.relativeGravity = 0
        director.actor = self
        display.scheme.info.color = float4(0.5, 0.5, 0.5, 1)
        body.object = self
        body.callback = { (body, _) in
            if let player = body.object as? Player {
                player.status.hitpoints.increase(-0.25)
            }
        }
    }
    
    func update() {
        director.update()
    }
}

class GameMap {
    let player: Player
    
    init(_ player: Player) {
        self.player = player
    }
}

class Director {
    var actor: Actor!
    let map: GameMap
    
    init(_ map: GameMap) {
        self.map = map
    }
    
    func update() {
        let dl = map.player.transform.location - actor.transform.location
        guard dl.length <= 20.m else { return }
        let direction = normalize(dl)
        let magnitude = 1.m * 0.8 + dl.length * 0.5
        actor.body.velocity = direction * magnitude
    }
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