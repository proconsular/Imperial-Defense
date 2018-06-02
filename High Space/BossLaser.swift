//
//  BossLaser.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossLaser {
    let transform: Transform
    
    let laser: Laser
    let pulseLaser: Laser
    let warningLaser: Laser
    
    var laserBlast: LaserBlastBehavior!
    var laserFire: Display!
    
    init(_ location: float2, _ transform: Transform, _ particle_shielding: ParticleShield) {
        self.transform = transform
        
        laser = Laser(location, 20, float2(0, 1))
        laser.audio = LaserAudio(laser, "laser")
        
        pulseLaser = Laser(location, 10, float2(0, 1))
        pulseLaser.audio = LaserAudio(pulseLaser, "laser")
        
        warningLaser = Laser(location, 2, float2(0, 1))
        warningLaser.audio = LaserAudio(warningLaser, "boss_laser_warning")
        warningLaser.color_first = float4(0.8, 0, 0, 1)
        warningLaser.color_second = float4(1, 1, 1, 1)
        
        laserFire = Display(Rect(location, float2(64)), GLTexture("laser-fire"))
        laserBlast = LaserBlastBehavior(Float.pi / 24, 6, laser, particle_shielding)
    }
    
    func update() {
        laser.transform.location = transform.location - float2(0, 0.5.m)
        laser.update()
        pulseLaser.transform.location = transform.location - float2(0, 0.5.m)
        pulseLaser.update()
        warningLaser.transform.location = transform.location - float2(0, 0.5.m)
        warningLaser.update()
        laserFire.transform.location = transform.location - float2(0, 0.5.m)
        laserFire.color = laser.display.color
        laserFire.refresh()
        if pulseLaser.visible {
            laserBlast.angle = atan2(pulseLaser.direction.y, pulseLaser.direction.x)
            laser.direction = pulseLaser.direction
        }
    }
    
    func render() {
        laser.render()
        pulseLaser.render()
        warningLaser.render()
    }
    
}
