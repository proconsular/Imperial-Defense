//
//  Shield.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/11/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class LifeDisplayAdapter: StatusItem {
    
    weak var life: Life?
    var base: float4
    var warnings: [PowerWarning]
    
    init(_ life: Life, _ color: float4) {
        self.life = life
        self.base = color
        warnings = []
    }
    
    func update() {
        if let life = life {
            warnings.forEach{ $0.update(life.percent) }
        }
    }
    
    var percent: Float {
        return life?.percent ?? 0
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
    
    var last: Float
    
    init(_ color: float4, _ frequency: Float, _ threshold: Float) {
        self.color = color
        self.frequency = frequency
        self.threshold = threshold
        counter = 0
        active = false
        last = 0
    }
    
    func update(_ percent: Float) {
        if percent > 0 && percent <= threshold {
            counter += Time.delta
            if counter >= frequency {
                counter = 0
                active = !active
                notify()
            }
        }else{
            active = false
        }
        last = percent
    }
    
    func notify() {
        let a = Audio("shield_weak")
        a.volume = 0.05
        a.start()
    }
    
    func apply(_ color: float4) -> float4 {
        return active ? self.color : color
    }
    
}

class NoShieldPowerWarning: ShieldLowPowerWarning {
    
    unowned let shield: Shield
    
    init(_ shield: Shield, _ color: float4, _ frequency: Float) {
        self.shield = shield
        super.init(color, frequency, 1)
    }
    
    override func update(_ percent: Float) {
        if shield.percent <= 0 {
            super.update(percent)
        }else{
            active = false
        }
    }
    
    override func notify() {
        Audio.play("health_warning", 0.025)
    }
    
}

protocol ShieldDelegate {
    func recover(_ percent: Float)
    func damage()
}

class ShieldAudio: ShieldDelegate {
    
    func recover(_ percent: Float) {
        if percent <= 0.9 {
            Audio.play("shield-regen", 0.2)
        }
    }
    
    func damage() {
       
    }
    
}

class EnemyShieldAudio: ShieldDelegate {
    
    func recover(_ percent: Float) {
//        if percent < 1 {
//            Audio.play("enemy_charge", 0.05)
//        }
    }
    
    func damage() {
        
    }
    
}

struct ShieldPower {
    var amount: Float
    var recharge: Float
    
    init(_ amount: Float, _ recharge: Float) {
        self.amount = amount
        self.recharge = recharge
    }
}

protocol ShieldEffect {
    func update()
}

class ShieldAbsorbEffect: ShieldEffect {
    unowned let transform: Transform
    unowned let shield: Shield
    let absorb: AbsorbEffect
    var percent: Float
    
    init(_ transform: Transform, _ shield: Shield, _ absorb: AbsorbEffect) {
        self.transform = transform
        self.shield = shield
        self.absorb = absorb
        percent = 0
    }
    
    func update() {
        absorb.update()
        if shield.broke {
            shield.explode(transform)
        }
        if shield.percent > percent {
            absorb.generate()
        }
        percent = shield.percent
    }
    
}

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

class PlayerShield: Shield {
    
    override func damage(_ amount: Float) {
        if upgrader.shieldpower.range.percent == 1 {
            if random(0, 1) <= 0.1 {
                return
            }
        }
        super.damage(amount)
    }
    
}

protocol Life: class {
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
    
    var shield: Shield?
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











