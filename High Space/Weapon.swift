//
//  Weapon.swift
//  Defender
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

import Foundation

struct BulletInfo {
    
    var damage: Int
    var speed: Float
    
    var size: float2
    var color: float4
    
    init(_ damage: Int, _ speed: Float, _ size: float2, _ color: float4) {
        self.damage = damage
        self.speed = speed
        self.size = size
        self.color = color
    }
    
}

class Weapon {
    
    var transform: Transform
    var direction: float2
   
    var tag: String
    
    var rate: Float = 0.25
    var counter: Float = 0
    
    var bullet_data: BulletInfo
    
    init(_ transform: Transform, _ direction: float2, _ data: BulletInfo, _ tag: String) {
        self.transform = transform
        self.direction = direction
        self.bullet_data = data
        self.tag = tag
    }
    
    func update() {
        counter += Time.time
    }
    
    var canFire: Bool {
        return counter >= rate
    }
    
    func fire() {
        counter = 0
        let bullet = Bullet(transform.location + 0.75.m * direction, direction, tag, bullet_data)
        if tag == "player" {
            bullet.body.mask = 0b11
        }else{
            bullet.body.mask = 0b100
        }
        Map.current.append(bullet)
    }
    
}
