//
//  Factory.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class GameCreator {
    
    static func createInterface() -> PlayerInterface {
        let sh = upgrader.shieldpower.range.percent
        return PlayerInterface(Player.player, 10.m + 4.m * sh, 7.m + 1.m * sh)
    }
    
    static func createBarriers() -> [Wall] {
        let constructor = BarrierConstructor(BarrierLayout(500, 2))
        upgrader.barrier.apply(constructor)
        return constructor.construct(-2.4.m)
    }
    
    static func createPlayer() -> Player {
        let shield = PlayerShield(Float(40), Float(2), Float(20))
        shield.delegate = ShieldAudio()
        let health = Health(30, shield)
        
        upgrader.shieldpower.apply(shield)
        
        let firer = Firer(0.1075, Impact(15, 14.m + 2.m * upgrader.firepower.range.percent), Casing(GameCreator.computeFireSize(), GameCreator.computeFireColor(), "enemy"))
        
        var power = Power(200, 115, 15)
        upgrader.firepower.apply(&power)
        
        return Player(float2(Camera.size.x / 2, -1.5.m), health, firer, power)
    }
    
    static func computeFireSize() -> float2 {
        let small_fire = float2(0.48.m, 0.144.m)
        let big_fire = float2(0.8.m, 0.16.m)
        return small_fire * (1 - upgrader.firepower.range.percent) + big_fire * upgrader.firepower.range.percent
    }
    
    static func computeFireColor() -> float4 {
        let green_fire = float4(0, 1, 0.5, 1)
        let purple_fire = float4(1, 1, 0.5, 1)
        return green_fire * (1 - upgrader.firepower.range.percent) + purple_fire * upgrader.firepower.range.percent
    }
    
    static func createWalls(_ map: Map, _ width: Float) {
        map.append(Structure(float2(map.size.x / 2, 0), float2(map.size.x, width)))
        map.append(Structure(float2(map.size.x / 2, -map.size.y), float2(map.size.x, width)))
        map.append(Structure(float2(0, -map.size.y / 2), float2(width, map.size.y)))
        map.append(Structure(float2(map.size.x, -map.size.y / 2), float2(width, map.size.y)))
    }
    
}

class GameSystem {
    
    static func start() {
        Graphics.method.clear()
        ParticleSystem.current.clear()
        BulletSystem.current.clear()
        GameplayController.current = GameplayController()
        Camera.current = Camera()
        Time.scale = 1
    }
    
    static func update() {
        ParticleSystem.current.update()
        BulletSystem.current.update()
        GameplayController.current.update()
    }
    
    static func render() {
        Graphics.render()
        ParticleSystem.current.render()
        BulletSystem.current.render()
    }
    
}























