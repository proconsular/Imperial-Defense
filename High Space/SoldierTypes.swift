//
//  SoldierTypes.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Scout: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(5, nil), float4(1))
        let firer = Firer(0.25, Impact(10, 8.m), Casing(float2(0.4.m, 0.1.m), float4(1, 0.25, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Scout").id
        animator.set(1)
        
        sprinter = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-light"))
        
    }
    
}

class Banker: Soldier {
    
    required init(_ location: float2) {
        let shield = Shield(Float(15), Float(2.0), Float(15))
        super.init(location, Health(45, shield), float4(1, 1, 0.25, 1))
        
        drop = CoinDrop(Int(clamp(GameData.info.wave / 10, min: 0, max: 2) + 1), 1)
        behavior.base.append(MarchBehavior(self, animator))
        canSprint = true
        
    }
    
}

class Captain: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(60), Float(0.75), Float(50))), float4(1))
        let firer = Firer(1.0, Impact(20, 10.m), Casing(float2(0.5.m, 0.13.m), float4(1, 0.5, 1, 1), "player", 2))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Captain").id
        
        canSprint = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(RushBehavior(transform, 3.m))
        
    }
    
}

class Commander: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(90), Float(0.5), Float(50))), float4(1))
        let firer = Firer(1.0, Impact(30, 10.m), Casing(float2(0.7.m, 0.175.m), float4(1, 0.25, 1, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Commander").id
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self))
        behavior.base.append(AllfireBehavior(self))
        
    }
    
}

class Thief: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, nil), float4(1))
        let firer = Firer(1.0, Impact(5, 12.m), Casing(float2(0.4.m, 0.1.m), float4(1, 0.25, 0.25, 1), "player"))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Thief").id
        animator.set(1)
        
        sprinter = true
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-light"))
        behavior.base.append(DodgeBehavior(self, 0.5))
        
    }
    
}

class Healer: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(15, Shield(Float(30), Float(0.1), Float(50))), float4(1))
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(HealBehavior(self))
        
        material["texture"] = GLTexture("Healer").id
    }
    
}

class Heavy: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(50, Shield(Float(50), Float(0.5), Float(50))), float4(1))
        let firer = Firer(1.5, Impact(30, 10.m), Casing(float2(0.5.m, 0.14.m) * 1.1, float4(1, 0, 1, 1), "player", 2))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Heavy").id
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-heavy"))
        behavior.base.append(RapidFireBehavior(self))
    }
    
}

class Sniper: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(30, Shield(Float(60), Float(0.5), Float(60))), float4(1))
        let firer = Firer(1.25, Impact(15, 25.m), Casing(float2(0.7.m, 0.15.m), float4(1, 0.5, 0.25, 1), "player", 2))
        weapon = Weapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Sniper").id
        
        behavior.base.append(MarchBehavior(self, animator))
        behavior.base.append(ShootBehavior(weapon!, self, "enemy-shoot-snipe"))
        behavior.base.append(DodgeBehavior(self, 0.6))
    }
    
    override func update() {
        super.update()
        if let player = Player.player {
            weapon?.direction = normalize(player.transform.location - transform.location)
        }
    }
    
}

class Mage: Soldier {
    
    required init(_ location: float2) {
        super.init(location, Health(45, Shield(Float(40), Float(0.1), Float(60))), float4(1))
        let firer = HomingFirer(1, Impact(30, 18.m), Casing(float2(0.8.m, 0.15.m), float4(1, 0.5, 1, 1), "player", 2))
        weapon = HomingWeapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Mage").id
        material.coordinates = SheetLayout(0, 12, 3).coordinates
//        display.refresh()
        
        behavior.base.append(GlideBehavior(self, 0.25.m))
        behavior.base.append(DodgeBehavior(self, 0.1))
        behavior.base.append(HomingShootBehavior(weapon!, self, Player.player))
    }
    
    override func update() {
        super.update()
        material.coordinates = SheetLayout(0, 12, 3).coordinates
    }
    
}

class Emperor: Soldier {
    
    static var instance: Emperor!
    
    let laser, pulseLaser: Laser
    let status_shield, status_health: PercentDisplay
    var particle_shielding: ParticleShield!
    
    var march: TimedBehavior!
    var march_animation: SheetAnimator!
    
    var laserBlast: LaserBlastBehavior!
    
    var laserFire: Display!
    
    var dead = false
    
    required init(_ location: float2) {
        laser = Laser(location, 20, float2(0, 1))
        pulseLaser = Laser(location, 10, float2(0, 1))
        
        let health = Health(2500, Shield(Float(50), Float(5), Float(60)))
        
//        health.damage(2500 * 0.75 + 50)
        
        let length = 40
        
        let loc = float2(Camera.size.x / 2, Camera.size.y * 0.7 - GameScreen.size.y)
        
        status_shield = PercentDisplay(loc, 30, length, 1, LifeDisplayAdapter(health.shield!, float4(48 / 255, 181 / 255, 206 / 255, 1)))
        status_shield.frame.color = float4(0)
        status_health = PercentDisplay(loc, 30, length, 1, LifeDisplayAdapter(health.stamina, float4(53 / 255, 215 / 255, 83 / 255, 1)))
        
        status_shield.move(-float2(status_shield.bounds.x / 2, 0))
        status_health.move(-float2(status_shield.bounds.x / 2, 0))
        
        super.init(location, health, float4(1))
        
        laserFire = Display(Rect(location, float2(64)), GLTexture("laser-fire"))
        
        particle_shielding = ParticleShield(transform, 1.0.m)
        
        let firer = HomingFirer(0.05, Impact(5, 18.m), Casing(float2(0.8.m, 0.15.m), float4(1, 0.5, 1, 1), "player"))
        weapon = HomingWeapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["texture"] = GLTexture("Emperor").id
        material["order"] = 200
        
        handle.materials.removeLast()
        
        animator = BaseMarchAnimator(body, 0.35, 26.m)
        let t = animator.player.animation as! TextureAnimator
        march_animation = t.list[0]
        
        setupBehaviors()
       
        Emperor.instance = self
    }
    
    func setupBehaviors() {
        laserBlast = LaserBlastBehavior(Float.pi / 24, 6, laser, particle_shielding)
        march = TimedBehavior(MarchBehavior(self, animator), 3)
        
        let clear = ActionBehavior{ [unowned self] in
            self.laser.visible = false
            self.pulseLaser.visible = false
        }
        
        let timeline = BossBehavior()
        behavior.push(timeline)
        
        
        timeline.append(ConditionalBehavior(setupFirstSegment()) { [unowned self] in
            self.health.stamina.percent > 0.75
        })
        timeline.append(clear)
        timeline.append(march)
        timeline.append(ConditionalBehavior(setupFirstSegmentVariation()) { [unowned self] in
            self.health.stamina.percent > 0.5 && self.health.stamina.percent <= 0.75
        })
        timeline.append(clear)
        timeline.append(march)
        timeline.append(ConditionalBehavior(setupSecondSegment()) { [unowned self] in
            self.health.stamina.percent > 0.25 && self.health.stamina.percent <= 0.5
        })
        timeline.append(clear)
        timeline.append(march)
        timeline.append(ConditionalBehavior(setupThirdSegment()) { [unowned self] in
            self.health.stamina.percent > 0.1 && self.health.stamina.percent <= 0.25
        })
        timeline.append(clear)
        timeline.append(TimedBehavior(MarchBehavior(self, animator), 5))
        timeline.append(ConditionalBehavior(setupClimaxSegment()) { [unowned self] in
            self.health.stamina.percent <= 0.1
        })
        
    }
    
    func setupFirstSegment() -> BossBehavior {
        let first = BossBehavior()
        
        first.append(march)
        first.append(DarkEnergyBlastBehavior(transform))
        first.append(StompBehavior(0.75, 4, 25))
        first.append(SummonLegionBehavior(transform))
        first.append(laserBlast)
        
        return first
    }
    
    func setupFirstSegmentVariation() -> BossBehavior {
        let first = setupFirstSegment()
        
        first.behaviors.removeLast()
        
        let selector = RandomBehavior()
        selector.behaviors.append(laserBlast)
        selector.behaviors.append(PulseLaserBlastBehavior(pulseLaser, particle_shielding))
        
        first.append(selector)
        
        return first
    }
    
    func setupSecondSegment() -> BossBehavior {
        let second = BossBehavior()
        
        second.append(march)
        second.append(RubbleFallBehavior())
        second.append(ParticleWaveBehavior(15.m, 3, transform))
        second.append(StompBehavior(0.5, 2, 35))
        second.append(PulseLaserBlastBehavior(pulseLaser, particle_shielding))
        second.append(StompBehavior(0.5, 2, 35))
        second.append(PulseLaserBlastBehavior(pulseLaser, particle_shielding))
        second.append(StompBehavior(0.5, 2, 35))
        second.append(PulseLaserBlastBehavior(pulseLaser, particle_shielding))
        second.append(RestBehavior(2, particle_shielding))
        
        return second
    }
    
    func setupThirdSegment() -> BossBehavior {
        let third = BossBehavior()
        
        third.append(march)
        third.append(ParticleBeamBehavior(transform))
        third.append(FastLaserBlastBehavior(Float.pi * 0.1, Float.pi / 4, 2, laser, particle_shielding))
        third.append(RestBehavior(0.25, particle_shielding))
        third.append(FastLaserBlastBehavior(Float.pi * 0.9, Float.pi / 4, 2, laser, particle_shielding))
        third.append(RestBehavior(0.25, particle_shielding))
        third.append(FastLaserBlastBehavior(Float.pi * 0.1, Float.pi / 4, 2, laser, particle_shielding))
        third.append(RestBehavior(0.25, particle_shielding))
        third.append(FastLaserBlastBehavior(Float.pi * 0.9, Float.pi / 4, 2, laser, particle_shielding))
        third.append(RestBehavior(0.25, particle_shielding))
        third.append(RandomBehavior([
            FastLaserBlastBehavior(Float.pi * 0.1, Float.pi / 4, 2, laser, particle_shielding),
            StompBehavior(0.5, 5, 30)
        ]))
        
        return third
    }
    
    func setupClimaxSegment() -> BossBehavior {
        let climax = BossBehavior()
        
        for _ in 0 ..< 4 {
            climax.append(FastLaserBlastBehavior(Float.pi * 0.3, Float.pi * 0.5, 0.5, laser, particle_shielding))
            climax.append(RestBehavior(0.25, particle_shielding))
            climax.append(FastLaserBlastBehavior(Float.pi * 0.7, Float.pi * 0.5, 0.5, laser, particle_shielding))
            climax.append(RestBehavior(0.25, particle_shielding))
            climax.append(StompBehavior(1, 3, 40))
        }
        
        climax.append(ParticleWaveBehavior(20.m, 2, transform))
        
        for _ in 0 ..< 3 {
            climax.append(StompBehavior(0.25, 2, 50))
            climax.append(PulseLaserBlastBehavior(pulseLaser, particle_shielding))
        }
        
        return climax
    }
    
    func setupOpener() {
        let opener = BossOpeningBehavior()
        behavior.push(opener)
        opener.behaviors.append(TimedBehavior(MarchBehavior(self, animator), 25))
        opener.behaviors.append(laserBlast)
    }
    
    override func damage(_ amount: Float) {
        if particle_shielding.enabled {
            if let e = particle_shielding.effect {
                if e is DefendEffect {
                    return
                }
            }else{
                particle_shielding.set(DefendEffect(3))
            }
        }
        super.damage(amount)
    }
    
    override func update() {
        if dead {
            behavior.update()
            return
        }
        
        super.update()
        
        laser.transform.location = transform.location - float2(0, 0.5.m)
        laser.update()
        pulseLaser.transform.location = transform.location - float2(0, 0.5.m)
        pulseLaser.update()
        
        laserFire.transform.location = transform.location - float2(0, 0.5.m)
        laserFire.color = laser.display.color
        laserFire.refresh()
        
        if pulseLaser.visible {
            laserBlast.angle = atan2(pulseLaser.direction.y, pulseLaser.direction.x)
        }
        
        status_shield.update()
        status_health.update()
        particle_shielding.update()
        
        reflective = false
        if let l = particle_shielding.effect, l is DefendEffect {
            reflective = true
        }
        
        let broke = Game.instance.scenery.castle.brokeness
        
        if health.stamina.percent <= 0.5 && broke < 1 {
            Game.instance.scenery.castle.brokeness = 1
            play("barrier-destroyed")
        }
        
        if health.stamina.percent <= 0.25 && broke < 2 {
            Game.instance.scenery.castle.brokeness = 2
            play("barrier-destroyed")
        }
        
        if health.stamina.percent <= 0.1 && !Game.instance.scenery.castle.destroyed {
            Game.instance.scenery.castle.destroy()
        }
        
        if health.stamina.percent <= 0.5 {
            if !Player.player.alive {
                Game.instance.endGame()
            }
        }
        
    }
    
    override func terminate() {
        if health.stamina.percent <= 0 && !dead {
            reflective = false
            particle_shielding.enabled = false
            behavior.push(DeathBehavior(self))
            dead = true
        }
    }
    
    override func render() {
        if !dead {
            laser.render()
            pulseLaser.render()
            
            status_health.render()
            status_shield.render()
        }
        
    }
    
}








