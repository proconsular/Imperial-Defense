//
//  BossShield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class BossShield {
    unowned let boss: Emperor
    var reflectiveShell: Body!
    var particle_shielding: ParticleShield!
    
    init(_ boss: Emperor) {
        self.boss = boss
        particle_shielding = ParticleShield(boss.transform, 1.0.m)
        reflectiveShell = Body(Circle(boss.transform, 1.25.m), Substance.getStandard(1))
        reflectiveShell.noncolliding = true
        boss.reaction = DamageReaction(boss)
    }
    
    func absorb(_ damage: Float) -> Float {
        if particle_shielding.enabled {
            if let e = particle_shielding.effect {
                if e is DefendEffect {
                    return 0
                }
            }else{
                Audio.play("boss_defend", 1)
                particle_shielding.set(DefendEffect(3))
            }
        }
        return damage
    }
    
    func update() {
        particle_shielding.update()
        if let l = particle_shielding.effect {
            if l is DefendEffect {
                if let react = boss.reaction, react is DamageReaction {
                    boss.reaction = ReflectReaction(reflectiveShell)
                }
            }else{
                boss.reaction = DamageReaction(boss)
            }
        }
    }
    
}
