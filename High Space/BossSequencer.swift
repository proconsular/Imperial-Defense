//
//  BossSequencer.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossSequencer {
    static var clear, wipeout, restoreShield: ActionBehavior!
    
    static func setSequence(_ boss: Emperor) {
        create(boss)
        setupBehaviors(boss, bossStage)
        if bossStage == 0 {
            setupOpener(boss)
        }
    }
    
    private static func create(_ boss: Emperor) {
        clear = ActionBehavior{ [unowned boss] in
            boss.laser.laser.visible = false
            boss.laser.pulseLaser.visible = false
        }
        wipeout = ActionBehavior{ [unowned boss] in
            let wipe = Explosion(boss.body.location, Camera.size.x)
            wipe.rate = 0.95
            Map.current.append(wipe)
        }
        restoreShield = ActionBehavior { [unowned boss] in
            boss.shield.particle_shielding.reset()
            boss.shield.particle_shielding.set(DefendEffect(2))
            Audio.play("boss_recover", 1)
        }
    }
    
    private static func setupBehaviors(_ boss: Emperor, _ stage: Int = 0) {
        let timeline = BossBehavior()
        boss.behavior.push(timeline)
        
        if stage == 0 {
            setSegment(timeline, boss, setupFirstSegment(boss), low: 0.75, high: 1)
            setWipeout(boss, timeline)
        }
        
        if stage <= 1 {
            setSegment(timeline, boss, setupFirstSegmentVariation(boss), low: 0.5, high: 0.75)
            setWipeout(boss, timeline)
        }
        
        if stage <= 2 {
            setSegment(timeline, boss, setupSecondSegment(boss), low: 0.25, high: 0.5)
            setWipeout(boss, timeline)
        }
        
        if stage <= 3 {
            setSegment(timeline, boss, setupThirdSegment(boss), low: 0.1, high: 0.25)
            timeline.append(clear)
            timeline.append(TimedBehavior(MarchBehavior(boss, boss.animator), 5))
        }
        
        setSegment(timeline, boss, setupClimaxSegment(boss), low: 0, high: 0.1)
    }
    
    private static func setSegment(_ timeline: BossBehavior, _ boss: Emperor, _ segment: BossBehavior, low: Float, high: Float) {
        timeline.append(ConditionalBehavior(segment) { [unowned boss] in
            boss.health.stamina.percent > low && boss.health.stamina.percent <= high
        })
    }
    
    private static func setWipeout(_ boss: Emperor, _ timeline: BossBehavior) {
        timeline.append(clear)
        timeline.append(wipeout)
        timeline.append(StompBehavior(2, 1, 50, "boss_wipeout"))
        timeline.append(restoreShield)
        timeline.append(boss.march)
    }
    
    private static func setupFirstSegment(_ boss: Emperor) -> BossBehavior {
        let first = BossBehavior()
        
        first.append(boss.march)
        first.append(TimedBehavior(UnitBehavior(EnergyWavePower(boss.transform, 0, 0.75)), 5))
        first.append(StompBehavior(0.75, 4, 25))
        first.append(SummonLegionBehavior(boss.transform))
        first.append(boss.laser.laserBlast)
        
        return first
    }
    
    private static func setupFirstSegmentVariation(_ boss: Emperor) -> BossBehavior {
        let first = setupFirstSegment(boss)
        first.behaviors.removeLast()
        
        let pulse = SequentialBossBehavior()
        pulse.behaviors.append(WarningLaserBehavior(boss.laser.warningLaser, 0.5))
        pulse.behaviors.append(PulseLaserBlastBehavior(boss.laser.pulseLaser, boss.laser.warningLaser, boss.shield.particle_shielding))
        
        let selector = RandomBehavior()
        selector.behaviors.append(boss.laser.laserBlast)
        selector.behaviors.append(pulse)
        
        first.append(selector)
        
        return first
    }
    
    private static func setupSecondSegment(_ boss: Emperor) -> BossBehavior {
        let second = BossBehavior()
        
        let pulse = SequentialBossBehavior()
        pulse.behaviors.append(WarningLaserBehavior(boss.laser.warningLaser, 0.5))
        pulse.behaviors.append(PulseLaserBlastBehavior(boss.laser.pulseLaser, boss.laser.warningLaser, boss.shield.particle_shielding))
        
        second.append(boss.march)
        second.append(RubbleFallBehavior())
        second.append(boss.march)
        second.append(ParticleWaveBehavior(15.m, 3, boss.transform))
        second.append(StompBehavior(0.5, 2, 35))
        second.append(pulse)
        second.append(StompBehavior(0.5, 2, 35))
        second.append(pulse)
        second.append(StompBehavior(0.5, 2, 35))
        second.append(pulse)
        second.append(RestBehavior(2, boss.shield.particle_shielding))
        
        return second
    }
    
    private static func setupThirdSegment(_ boss: Emperor) -> BossBehavior {
        let third = BossBehavior()
        
        let speed = Float.pi / 3
        let length: Float = 1.5
        
        third.append(boss.march)
        third.append(ParticleBeamBehavior(boss.transform))
        third.append(FastLaserBlastBehavior(Float.pi * 0.1, speed, length, boss.laser.laser, boss.shield.particle_shielding))
        third.append(RestBehavior(0.25, boss.shield.particle_shielding))
        third.append(FastLaserBlastBehavior(Float.pi * 0.9, speed, length, boss.laser.laser, boss.shield.particle_shielding))
        third.append(RestBehavior(0.25, boss.shield.particle_shielding))
        third.append(FastLaserBlastBehavior(Float.pi * 0.1, speed, length, boss.laser.laser, boss.shield.particle_shielding))
        third.append(RestBehavior(0.25, boss.shield.particle_shielding))
        third.append(FastLaserBlastBehavior(Float.pi * 0.9, speed, length, boss.laser.laser, boss.shield.particle_shielding))
        third.append(RestBehavior(0.25, boss.shield.particle_shielding))
        third.append(RandomBehavior([
            FastLaserBlastBehavior(Float.pi * 0.1, speed, 2, boss.laser.laser, boss.shield.particle_shielding),
            StompBehavior(0.5, 5, 30)
            ]))
        
        return third
    }
    
    private static func setupClimaxSegment(_ boss: Emperor) -> BossBehavior {
        let climax = BossBehavior()
        
        let pulse = SequentialBossBehavior()
        pulse.behaviors.append(WarningLaserBehavior(boss.laser.warningLaser, 0.5))
        pulse.behaviors.append(PulseLaserBlastBehavior(boss.laser.pulseLaser, boss.laser.warningLaser, boss.shield.particle_shielding))
        
        climax.append(WarningLaserBehavior(boss.laser.warningLaser, Float.pi * 0.3, 0.25))
        for _ in 0 ..< 4 {
            climax.append(WarningLaserBehavior(boss.laser.warningLaser, Float.pi * 0.3, 0.25))
            climax.append(FastLaserBlastBehavior(Float.pi * 0.3, Float.pi * 0.5, 0.5, boss.laser.laser, boss.shield.particle_shielding))
            climax.append(RestBehavior(0.25, boss.shield.particle_shielding))
            climax.append(WarningLaserBehavior(boss.laser.warningLaser, Float.pi * 0.7, 0.25))
            climax.append(FastLaserBlastBehavior(Float.pi * 0.7, Float.pi * 0.5, 0.5, boss.laser.laser, boss.shield.particle_shielding))
            climax.append(RestBehavior(0.25, boss.shield.particle_shielding))
            climax.append(StompBehavior(1, 3, 40))
        }
        
        climax.append(ParticleWaveBehavior(20.m, 2, boss.transform))
        
        for _ in 0 ..< 3 {
            climax.append(StompBehavior(0.25, 2, 50))
            climax.append(pulse)
        }
        
        return climax
    }
    
    private static func setupOpener(_ boss: Emperor) {
        let opener = BossOpeningBehavior()
        boss.behavior.push(opener)
        opener.behaviors.append(TimedBehavior(MarchBehavior(boss, boss.animator), 6))
        opener.behaviors.append(boss.laser.laserBlast)
    }
    
}
