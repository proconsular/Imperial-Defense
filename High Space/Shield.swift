//
//  Shield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class Shield: Life {
    var points: PointRange
    var timer: Timer!
    var damaged = false
    var broke = false
    
    var delegates: [ShieldDelegate]
    var effect: ShieldEffect?
    
    var power: ShieldPower
    
    var mods: [ShieldPower]
    
    init(_ amount: Float, _ timeout: Float, _ recharge: Float) {
        power = ShieldPower(amount, recharge)
        points = PointRange(amount)
        mods = []
        delegates = []
        timer = Timer(timeout, recover)
    }
    
    func set(_ percent: Float) {
        points.amount = points.limit * percent
    }
    
    func recover() {
        self.damaged = false
        delegates.forEach{ $0.recover(percent) }
    }
    
    func damage(_ amount: Float) {
        damaged = true
        timer.increment = 0
        let previous = points.amount
        points.increase(-amount)
        broke = points.amount == 0 && previous > 0
        delegates.forEach{ $0.damage() }
    }
    
    func explode(_ transform: Transform) {
        Audio.play("shield_break", 0.025)
        let explosion = Explosion(transform.location, 1.m)
        explosion.color = float4(0.2, 0.6, 1, 1)
        Map.current.append(explosion)
    }
    
    func update() {
        let final = computeFinalPower()
        if damaged {
            timer.update(Time.delta)
        }else{
            points.limit = final.amount
            if points.amount < points.limit {
                 points.recharge(final.recharge * Time.delta)
            }
        }
        effect?.update()
        broke = false
    }
    
    func computeFinalPower() -> ShieldPower {
        var final = power
        for m in mods {
            final.amount += m.amount
            final.recharge += m.recharge
        }
        return final
    }
    
    func apply(_ color: float4) -> float4 {
        let final = computeFinalPower()
        let percent = ((points.amount / final.amount) + (points.amount > 0 ? 0.4 : 0)) * 0.9
        return (color - float4(percent * 0.6)) + float4(0.2, 0.6, 1, 1) * float4(percent)
    }
    
    var percent: Float {
        return points.percent
    }
}











