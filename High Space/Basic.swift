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
        timer = Timer(4) {
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
            points.increase(70 * Time.time)
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
    static var level: Int = 0
    static var points: Int = 0
    static var upgrade = SniperBulletUpgrade()
    static var inventory = Inventory()
}

class Player: Actor, Interface {
    static var player: Player!
    
    var shield: Shield
    var weapon: Weapon!
    
    init(_ location: float2) {
        shield = Shield(amount: 100)
        let transform = Transform(location)
        let up = Score.upgrade.computeInfo()
        weapon = Weapon(transform, float2(0, -1), BulletInfo(up.damage + 1, 10.m + up.speed, float2(0.4.m, 0.08.m), float4(0, 1, 0, 1)), "enemy")
        super.init(Rect(transform, float2(0.8.m, 1.4.m)), Substance(Material(.wood), Mass(6, 0), Friction(.iron)))
        body.mask = 0b10
        body.object = self
        display.texture = GLTexture("player").id
        Player.player = self
        order = 100
    }
    
    func use(_ command: Command) {
        if command.id == 0 {
            let force = command.vector! / 5
            if abs(body.velocity.x) < 7.m {
                body.velocity.x += force.x
            }
        }else if command.id == 1 {
            if weapon.canFire {
                weapon.fire()
                play("shoot2", 0.6)
            }
        }
    }
    
    override func update() {
        shield.update()
        weapon.update()
        body.velocity.x *= 0.8
        body.velocity.y = 0
    }
    
}

class Bullet: Actor {
    var info: BulletInfo
    
    init(_ location: float2, _ direction: float2, _ tag: String, _ info: BulletInfo) {
        self.info = info
        super.init(Rect(location, info.size), Substance(Material(.wood), Mass(0.01, 0), Friction(.iron)))
        display.scheme.info.texture = GLTexture("bullet").id
        display.color = info.color
        body.callback = { (body, collision) in
            if tag == "enemy" {
                if let char = body.object as? Soldier {
                    char.health -= self.info.damage
                    play("hit1", 1.5)
                }
                if !(body.object is Player) {
                    self.alive = false
                }
            }
            if tag == "player" {
                if let pla = body.object as? Player {
                    pla.shield.damage(Float(self.info.damage))
                    play("hit1")
                }
                if !(body.object is Soldier) {
                    self.alive = false
                }
            }
            if let char = body.object as? Wall {
                char.health -= self.info.damage
                play("hit1", 1.5)
            }
        }
        body.velocity = info.speed * direction
        body.orientation = atan2(direction.y, direction.x)
        body.mask = 0b01111
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

