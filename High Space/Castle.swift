//
//  Castle.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/12/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class Castle {
    let normal_piece: Display
    var broken_pieces: [Display]
    
    var brokeness: Int
    var destroyed: Bool
    var falling_apart: Bool
    
    var fall_index: Int
    var velocity: float2
    
    var barriers: [Wall]
    
    init(_ location: float2) {
        let bounds = float2(Camera.size.x, 256)
        normal_piece = Display(Rect(location, bounds), GLTexture("stonefloor"))
        normal_piece.order = -2
        
        let center = Display(Rect(location, bounds), GLTexture("Castle-Centerpiece"))
        center.order = -2
        let right = Display(Rect(location, bounds), GLTexture("Castle-Rightpiece"))
        right.order = -2
        let left = Display(Rect(location, bounds), GLTexture("Castle-Leftpiece"))
        left.order = -2
        
        broken_pieces = []
        broken_pieces.append(left)
        broken_pieces.append(right)
        broken_pieces.append(center)
        
        brokeness = 0
        destroyed = false
        falling_apart = false
        fall_index = 0
        velocity = float2()
        barriers = []
    }
    
    func destroy() {
        if fall_index == 0 {
            falling_apart = true
        }
    }
    
    func update() {
        barriers = barriers.filter{ $0.alive }
        
        if falling_apart {
            let side = broken_pieces[fall_index]
            var barrier: Wall?
            
            if fall_index * 2 < barriers.count {
                barrier = barriers[fall_index * 2]
            }
            
            velocity += float2(0, 6.m) * Time.delta
            side.transform.location += velocity * Time.delta
            barrier?.transform.location += velocity * Time.delta
            velocity *= 0.95
            
            if side.transform.location.y >= -0.1.m {
                side.color = float4(0)
                if let wall = barrier {
                    wall.damage(wall.health)
                }
                fall_index += 1
                velocity = float2()
                let place = float2((fall_index == 1 ? Camera.size.x * 0.75 : Camera.size.x * 0.25), 0)
                let exp = Explosion(side.transform.location + place, 5.m)
                Map.current.append(exp)
            }
            side.refresh()
            if fall_index >= 2 {
                destroyed = true
                falling_apart = false
            }
        }
        if destroyed || falling_apart {
            if let player = Player.player {
                if player.transform.location.x <= Camera.size.x * 0.325 {
                    player.transform.location.x = Camera.size.x * 0.325
                }
                if player.transform.location.x >= Camera.size.x * 0.675 {
                    player.transform.location.x = Camera.size.x * 0.675
                }
            }
        }
    }
    
    func render() {
        if brokeness < 2 {
            normal_piece.render()
        }
        if brokeness > 0 && !destroyed {
            if brokeness == 1 {
                broken_pieces[0].render()
            }else{
                for i in 0 ..< broken_pieces.count {
                    broken_pieces[i].render()
                }
            }
        }
        if destroyed {
            broken_pieces.last?.render()
        }
    }
    
}
