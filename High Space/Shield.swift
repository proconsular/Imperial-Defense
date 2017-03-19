//
//  Shield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LifeDisplayAdapter: StatusItem {
    
    var life: Life
    var base: float4
    var warnings: [PowerWarning]
    
    init(_ life: Life, _ color: float4) {
        self.life = life
        self.base = color
        warnings = []
    }
    
    func update() {
        warnings.forEach{ $0.update(life.percent) }
    }
    
    var percent: Float {
        return life.percent
    }
    
    var color: float4 {
        var c = base
        warnings.forEach{ c = $0.apply(c) }
        return c
    }
    
}

protocol PowerWarning {
    func update(_ percent: Float)
    func apply(_ color: float4) -> float4
}

class ShieldLowPowerWarning: PowerWarning {
    
    var color: float4
    var frequency: Float
    var threshold: Float
    
    var counter: Float
    var active: Bool
    
    init(_ color: float4, _ frequency: Float, _ threshold: Float) {
        self.color = color
        self.frequency = frequency
        self.threshold = threshold
        counter = 0
        active = false
    }
    
    func update(_ percent: Float) {
        if percent > 0 && percent <= threshold {
            counter += Time.delta
            if counter >= frequency {
                counter = 0
                active = !active
                play("shield_weak")
            }
        }else{
            active = false
        }
    }
    
    func apply(_ color: float4) -> float4 {
        return active ? self.color : color
    }
    
}

protocol ShieldDelegate {
    func recover(_ percent: Float)
    func damage()
}

class ShieldAudio: ShieldDelegate {
    
    func recover(_ percent: Float) {
        if percent <= 0.9 {
            play("shield-re1")
        }
    }
    
    func damage() {
        playIfNot("hit8", 0.65)
    }
    
}

class Shield: Life {
    var points: PointRange
    var timer: Timer!
    var damaged = false
    var broke = false
    var recharge: Float
    
    var delegate: ShieldDelegate?
    
    init(_ amount: Float, _ timeout: Float, _ recharge: Float) {
        self.recharge = recharge
        points = PointRange(amount)
        timer = Timer(timeout, recover)
    }
    
    func recover() {
        self.damaged = false
        delegate?.recover(points.percent)
    }
    
    func damage(_ amount: Float) {
        damaged = true
        timer.increment = 0
        let previous = points.amount
        points.increase(-amount)
        broke = points.amount == 0 && previous > 0
        delegate?.damage()
    }
    
    func explode(_ transform: Transform) {
        let explosion = Explosion(transform.location, 1.m)
        explosion.color = float4(0.2, 0.6, 1, 1)
        Map.current.append(explosion)
    }
    
    func update() {
        if damaged {
            timer.update(Time.delta)
        }else{
            points.recharge(recharge * Time.delta)
        }
        broke = false
    }
    
    func apply(_ color: float4) -> float4 {
        let percent = (points.percent + (points.amount > 0 ? 0.4 : 0)) * 0.9
        return (color - float4(percent * 0.6)) + float4(0.2, 0.6, 1, 1) * float4(percent)
    }
    
    var percent: Float {
        return points.percent
    }
    
}

protocol Life {
    func damage(_ amount: Float)
    var percent: Float { get }
}

class Stamina: Life {
    
    var points: PointRange
    
    init(_ limit: Float) {
        points = PointRange(limit)
    }
    
    func damage(_ amount: Float) {
        points.increase(-amount)
    }
    
    var percent: Float {
        return points.percent
    }
    
}

class Health: Life {
    
    let shield: Shield?
    let stamina: Stamina
    
    init(_ amount: Float, _ shield: Shield?) {
        stamina = Stamina(amount)
        self.shield = shield
    }
    
    func damage(_ amount: Float) {
        var final_amount: Float = amount
        if let shield = shield {
            final_amount = max(amount - shield.points.amount, 0)
            shield.damage(amount)
        }
        stamina.damage(final_amount)
    }
    
    var percent: Float {
        return ((shield?.percent ?? 0) + stamina.percent) / 2
    }
    
}











