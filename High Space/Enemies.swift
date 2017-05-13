//
//  Enemies.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 10/9/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BaseMarchAnimator: Animator {
    
    init(_ body: Body, _ rate: Float, _ speed: Float) {
        let animation = TextureAnimator(SheetLayout(0, 12, 3))
        animation.append(SheetAnimation(0, 12, 12, 1))
        super.init(TimedAnimationPlayer(rate, animation), Marcher(body, speed), [3, 9])
    }
    
}

protocol ActorTerminationDelegate {
    func terminate()
}

protocol Drop {
    func release(_ location: float2)
}

class CoinDrop: Drop {
    
    let amount: Int
    let chance: Float
    
    init(_ amount: Int, _ chance: Float) {
        self.amount = amount
        self.chance = chance
    }
    
    func release(_ location: float2) {
        guard random(0, 1) <= chance else { return }
        for _ in 0 ..< amount {
            let coin = Coin(location, 1)
            let angle = random(-Float.pi, Float.pi)
            let mag = random(2, 4) * 1.m
            coin.body.velocity = float2(cos(angle), sin(angle)) * mag
            Map.current.append(coin)
        }
    }
    
}

class SoldierTerminator: ActorTerminationDelegate {
    
    unowned let soldier: Soldier
    
    init(_ soldier: Soldier) {
        self.soldier = soldier
    }
    
    func terminate() {
        let a = Audio("explosion1")
        a.volume = sound_volume
        a.start()
        soldier.drop?.release(soldier.transform.location)
    }
    
}
















