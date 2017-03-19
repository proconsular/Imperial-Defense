//
//  Player.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/22/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class PlayerInterface: Interface {
    
    var player: Player
    var speed: Float 
    var acceleration: Float
    
    init(_ player: Player, _ speed: Float, _ acceleration: Float) {
        self.player = player
        self.speed = speed
        self.acceleration = acceleration
    }
    
    func use(_ command: Command) {
        if command.id == 0 {
            let force = command.vector! / 1000
            if abs(player.body.velocity.x) < speed {
                player.body.velocity.x += force.x * acceleration
            }
        }else if command.id == 1 {
            if player.weapon.canFire {
                let shoot = Audio("shoot2")
                shoot.pitch = player.weapon.isHighPower ? 0.6 : 1
                shoot.start()
                player.weapon.fire()
            }
            player.firing = true
        }
    }
    
}

class Affector {
    
    var damaged: Bool
    var counter: Float
    var a: Float
    
    init() {
        damaged = false
        counter = 0
        a = 0
    }
    
    func apply(_ color: float4) -> float4 {
        if damaged {
            counter += Time.delta
            if counter >= 1 {
                counter = 0
                damaged = false
            }else{
                a += Time.delta
                let r: Float = 0.1
                if a >= r {
                    a = 0
                }
                if a >= r / 2 {
                    return float4(1, 0, 0, 1)
                }
                
            }
        }
        return color
    }
    
}

class ExplosionTerminator: ActorTerminationDelegate {
    
    let actor: Entity
    let radius: Float
    let color: float4
    
    init(_ actor: Entity, _ radius: Float, _ color: float4) {
        self.actor = actor
        self.radius = radius
        self.color = color
    }
    
    func terminate() {
        let explosion = Explosion(actor.transform.location, radius)
        explosion.color = color
        explosion.rate = 0.9
        Map.current.append(explosion)
        let audio = Audio("explosion1")
        audio.volume = 1
        audio.start()
    }
    
}

class Player: Entity {
    static var player: Player!
    
    var health: Health
    var weapon: PlayerWeapon!
    var drag: Float = 0.7
    var firing = false
    var affector: Affector
    var terminator: ActorTerminationDelegate?
    
    init(_ location: float2) {
        let shield = Shield(Float(70), Float(2), Float(40))
        shield.delegate = ShieldAudio()
        health = Health(30, shield)
        
        let transform = Transform(location)
        
        weapon = PlayerWeapon(transform, float2(0, -1), BulletInfo(15, 14.m, Float(0.1075), float2(0.4.m, 0.12.m) * 1.2, float4(0, 1, 0.5, 1)), "enemy")
        
        affector = Affector()
        
        super.init(Rect(transform, float2(0.8.m, 1.4.m)), Substance(PhysicalMaterial(.wood), Mass(10, 0), Friction(.iron)))
       
        body.mask = 0b10
        body.object = self
        display.texture = GLTexture("soldier").id
        
        Player.player = self
        display.scheme.schemes[0].order  = 100
        
        terminator = ExplosionTerminator(self, 3.m, float4(1, 1, 1, 1))
    }
    
    func hit(amount: Int) {
        health.damage(Float(amount))
        play("hit1")
        affector.damaged = true
    }
    
    override func update() {
        if let shield = health.shield {
            display.color = shield.apply(float4(1))
            display.color = affector.apply(display.color)
            if shield.broke {
                shield.explode(transform)
            }
            shield.update()
        }
        weapon.update()
        body.velocity.x *= drag
        if firing {
            body.velocity.x *= 0.8
        }
        firing = false
        if health.percent <= 0 {
            alive = false
            terminator?.terminate()
        }
    }
    
}












