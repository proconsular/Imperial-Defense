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
    var canFire = true
    
    init(_ player: Player, _ speed: Float, _ acceleration: Float) {
        self.player = player
        self.speed = speed
        self.acceleration = acceleration
    }
    
    func use(_ command: Command) {
        if player.dead { return }
        if command.id == 0 {
            let force = command.vector! / 1000
            if abs(player.body.velocity.x) < speed {
                player.body.velocity.x += force.x * acceleration
            }
        }else if command.id == 1 && canFire {
            if player.weapon.canFire {
                let shoot = Audio("player-shoot")
                shoot.pitch = player.weapon.isHighPower ? 0.6 : 1
                shoot.volume = sound_volume
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
        let audio = Audio("player-die")
        audio.volume = 1
        audio.start()
    }
    
}

class Player: Entity, Damagable {
    static var player: Player!
    
    var health: Health
    var weapon: PlayerWeapon!
    var drag: Float = 0.7
    var firing = false
    var affector: Affector
    var terminator: ActorTerminationDelegate?
    
    let animator: TextureAnimator
    
    var anim_timer: Float = 0
    
    var absorb: AbsorbEffect!
    
    var death_timer: Float = 0
    var dead: Bool = false
    
    init(_ location: float2, _ health: Health, _ firer: Firer, _ power: Power) {
        self.health = health
        
        let transform = Transform(location)
        weapon = PlayerWeapon(transform, float2(0, -1), power, firer)
        
        affector = Affector()
        
        animator = TextureAnimator(GLTexture("Player").id, SheetLayout(0, 8, 4))
        animator.append(SheetAnimator(0.1, [], SheetAnimation(0, 5, 8, 1)))
        animator.append(SheetAnimator(0.25, [], SheetAnimation(8, 4, 8, 1)))
        
        let image = Rect(transform, float2(48, 48) * 4)
        let bodyhall = Rect(transform, float2(100, 100))
        
        super.init(image, bodyhall, Substance(PhysicalMaterial(.wood), Mass(10, 0), Friction(.iron)))
        
        body.tag = "player"
        
        body.mask = 0b10
        body.object = self
        display.texture = GLTexture("Player").id
        display.coordinates = animator.coordinates
        
        Player.player = self
        display.order  = 100
        
        terminator = ExplosionTerminator(self, 5.m, float4(1, 1, 1, 1))
        
        let blue = float4(48 / 255, 181 / 255, 206 / 255, 1)
        let green = float4(63 / 255, 206 / 255, 48 / 255, 1)
        let color = blue * (1 - upgrader.shieldpower.range.percent) + green * upgrader.shieldpower.range.percent
        display.technique = ShieldTechnique(health.shield!, transform, color, image.bounds.y)
        
        absorb = AbsorbEffect(3, 0.025, 1.25.m, 7, color, 0.75.m, body)
    }
    
    func damage(_ amount: Float) {
        health.damage(amount)
        let h = Audio("hit1")
        h.volume = sound_volume
        h.start()
        affector.damaged = true
    }
    
    override func update() {
        absorb.update()
        if !dead {
            if let shield = health.shield {
                display.color = float4(1)
                display.color = affector.apply(display.color)
                if shield.broke {
                    shield.explode(transform)
                }
                let a = shield.percent
                shield.update()
                let b = shield.percent
                if a < b {
                    absorb.generate()
                }
            }
        }
        
        let per = weapon.percent
        weapon.update()
        if !firing {
            if per < 1 && weapon.percent >= 1 {
                let audio = Audio("power_full")
                audio.volume = sound_volume
                audio.start()
            }
        }
        
        body.velocity.x *= drag
        if firing {
            body.velocity.x *= 0.8
        }
        firing = false
        
        
        if health.percent <= 0 {
            if !dead {
                let die = Audio("player_died")
                die.volume = 1
                die.start()
            }
            dead = true
            animator.set(1)
            Audio("1 Battle").stop()
            Game.instance.physics.speed = 0.05
        }
        
        if dead {
            death_timer += Time.delta
            if death_timer >= 5 {
                alive = false
                Game.instance.physics.speed = 1
                terminator?.terminate()
            }
            let c = Float(Int(death_timer * 400) % 2)
            display.color = float4(1, c, c, 1)
            anim_timer += Time.delta
            if anim_timer >= 1 && animator.frame < 11 {
                anim_timer = 0
                let die = Audio("player_fall")
                die.volume = 0.75
                die.start()
                animator.animate()
            }
        }
        
        if !dead {
            if abs(body.velocity.x) >= 2 {
                anim_timer += Time.delta
                if anim_timer >= 0.05 {
                    anim_timer = 0
                    animator.animate()
                    if animator.frame == 2 {
                        let step = Audio("player-step")
                        step.volume = 0.75
                        step.start()
                    }
                }
            }else{
                animator.current.animation.index = 0
            }
        }
        
        display.coordinates = animator.coordinates
    }
    
}












