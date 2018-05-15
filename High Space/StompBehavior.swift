//
//  StompBehavior.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class StompBehavior: ActiveBehavior {
    var alive: Bool = true
    var active: Bool = true
    
    var timer, rate: Float
    var count, amount: Int
    
    var power, direction: Float
    var magnitude: Float
    
    init(_ rate: Float, _ amount: Int, _ magnitude: Float) {
        self.rate = rate
        self.amount = amount
        self.magnitude = magnitude
        timer = 0
        count = 0
        power = 0
        direction = 1
    }
    
    func activate() {
        active = true
        timer = 0
        count = 0
        power = 0
    }
    
    func update() {
        timer += Time.delta
        if timer >= rate - rate / 2 * FinalBattle.instance.challenge {
            power += 1
            timer = 0
            count += 1
            if count >= amount {
                active = false
                Camera.current.transform.location.x = 0
                return
            }
            let audio = Audio("stomp")
            audio.volume = 1
            audio.start()
        }
        power = clamp(power - Time.delta, min: 0, max: 1)
        shake()
    }
    
    func shake() {
        Camera.current.transform.location.x = power * (magnitude + magnitude * FinalBattle.instance.challenge) * direction
        direction = -direction
    }
}
