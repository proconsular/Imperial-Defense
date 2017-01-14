//
//  Player.swift
//  Defender
//
//  Created by Chris Luttio on 10/22/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Player: Actor, Interface {
    static var player: Player!
    
    var shield: Shield
    var weapon: Weapon!
    var bomb: Weapon!
    var laser: LaserWeapon!
    var damaged = false
    var speed: Float
    
    var dmg_counter: Float = 0
    
    init(_ location: float2) {
        shield = Shield(amount: Float(100 + Data.info.health.computeAmount()))
        let transform = Transform(location)
        
        weapon = Player.setupWeapon(transform)
        bomb = Player.setupBomb(transform)
        laser = Player.setupLaser(transform)
        
        speed = 4.m + Data.info.movement.computeSpeed()
        
        super.init(Rect(transform, float2(0.8.m, 1.4.m)), Substance(Material(.wood), Mass(10, 0), Friction(.iron)))
        body.mask = 0b10
        body.object = self
        display.texture = GLTexture("soldier").id
        Player.player = self
        order = 100
    }
    
    private static func setupWeapon(_ transform: Transform) -> Weapon {
        let up = Data.info.sniper.computeInfo()!
        let ma = Data.info.machine.computeInfo()!
        let bo = Data.info.bomb.computeInfo()!
        let weapon = Weapon(transform, float2(0, -1), BulletInfo(up.damage + ma.damage + bo.damage + 3, 8.m + up.speed + ma.speed + bo.speed, 0.125, float2(0.4.m, 0.12.m) * 1.1, float4(0, 1, 0.5, 1)), "enemy")
        weapon.bullet_data.collide = bo.collide
        return weapon
    }
    
    private static func setupBomb(_ transform: Transform) -> Weapon {
        var b = BulletInfo(1, 5.m, 3.5, float2(0.5.m, 0.5.m), float4(0, 0, 0, 1))
        b.collide = {
            let radius = 4.m
            let actors = Map.current.getActors(rect: FixedRect($0.body.location, float2(radius)))
            for a in actors {
                if let s = a as? Soldier {
                    s.damage(amount: 70)
                }
            }
            Map.current.append(Explosion($0.body.location, radius))
            let a = Audio("explosion1")
            a.volume = 1
            a.pitch = 0.6
            a.start()
        }
        let bomb = Weapon(transform, float2(0, -1), b, "enemy")
        return bomb
    }
    
    private static func setupLaser(_ transform: Transform) -> LaserWeapon {
        let la = Laser(transform.location, 0.05.m, 1)
        let laser = LaserWeapon(la) {
            if let s = $0 as? Soldier {
                s.health -= 50
            }
        }
        return laser
    }
    
    func use(_ command: Command) {
        if command.id == 0 {
            let force = command.vector! / 2
            if abs(body.velocity.x) < speed {
                body.velocity.x += force.x
            }
        }else if command.id == 1 {
            if weapon.canFire {
                weapon.fire()
                let shoot = Audio("shoot2")
                shoot.start()
            }
        }else if command.id == 2 {
            if Data.info.level > 10 {
                if bomb.canFire {
                    bomb.fire()
                    play("shoot2", 0.4)
                }
            }
        }else if command.id == 3 {
            if Data.info.level > 20 {
                laser.fire()
            }
        }
    }
    
    func hit(amount: Int) {
        shield.damage(Float(amount))
        play("hit1")
        damaged = true
    }
    
    override func update() {
        shield.update()
        weapon.update()
        bomb.update()
        laser.laser.transform.location = transform.location + float2(0, -0.75.m)
        laser.update()
        
        if damaged {
            dmg_counter += Time.time
            if dmg_counter >= 2 {
                dmg_counter = 0
                damaged = false
                display.color = float4(1)
            }else{
                display.color = arc4random() % 3 == 0 ? float4(1, 0, 0, 1) : float4(1)
            }
            display.visual.refresh()
        }
        
        body.velocity.x *= 0.75
        body.velocity.y = 0
    }
    
    override func render() {
        super.render()
        laser.render()
    }
    
}
