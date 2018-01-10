//
//  SoldierTypes.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

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
    
    var reflectiveShell: Body!
    
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
        
        super.init(location, health, float4(1), "Emperor")
        
        laserFire = Display(Rect(location, float2(64)), GLTexture("laser-fire"))
        
        particle_shielding = ParticleShield(transform, 1.0.m)
        
        let firer = HomingFirer(0.05, Impact(5, 18.m), Casing(float2(0.8.m, 0.15.m), float4(1, 0.5, 1, 1), "player"))
        weapon = HomingWeapon(transform, float2(0, 1), firer)
        weapon?.offset = float2(-0.2.m, -0.7.m)
        
        material["order"] = 200
        
        handle.materials.removeLast()
        
        animator = BaseMarchAnimator(body, 0.35, 26.m)
        let t = animator.player.animation as! TextureAnimator
        march_animation = t.list[0]
        
        setupBehaviors()
        
        reaction = DamageReaction(self)
        
        reflectiveShell = Body(Circle(transform, 1.25.m), Substance.getStandard(1))
        reflectiveShell.noncolliding = true
        
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
        
        if let l = particle_shielding.effect {
            if l is DefendEffect {
                if let react = reaction, react is DamageReaction {
                    reaction = ReflectReaction(reflectiveShell)
                }
            }else{
                reaction = DamageReaction(self)
            }
        }
        
        let broke = Game.instance.level.scenery.castle.brokeness
        
        if health.stamina.percent <= 0.5 && broke < 1 {
            Game.instance.level.scenery.castle.brokeness = 1
            play("barrier-destroyed")
        }
        
        if health.stamina.percent <= 0.25 && broke < 2 {
            Game.instance.level.scenery.castle.brokeness = 2
            play("barrier-destroyed")
        }
        
        if health.stamina.percent <= 0.1 && !Game.instance.level.scenery.castle.destroyed {
            Game.instance.level.scenery.castle.destroy()
        }
    }
    
    override func terminate() {
        if health.stamina.percent <= 0 && !dead {
            //reflective = false
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








