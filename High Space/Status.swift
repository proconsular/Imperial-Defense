//
//  Status.swift
//  Defender
//
//  Created by Chris Luttio on 12/24/16.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

struct PointRange {
    var amount: Float
    var limit: Float
    
    init(_ limit: Float) {
        self.limit = limit
        amount = limit
    }
    
    var percent: Float {
        return amount / limit
    }
    
    mutating func increase(_ amount: Float) {
        self.amount += amount
        self.amount = clamp(self.amount, min: 0, max: limit)
    }
}

class Status {
    var hitpoints: PointRange
    
    init(_ limit: Float) {
        hitpoints = PointRange(limit)
    }
}

class Shield: StatusItem {
    var points: PointRange
    var damaged = false
    var timer: Timer!
    
    init(amount: Float) {
        points = PointRange(amount)
        timer = Timer(3) {
            self.damaged = false
            if self.points.percent <= 0.9 {
                play("shield-re1", 0.75)
            }
        }
    }
    
    var percent: Float {
        return points.percent
    }
    
    func damage(_ amount: Float) {
        damaged = true
        timer.increment = 0
        points.increase(-amount)
        playIfNot("hit8", 0.65)
    }
    
    func update() {
        if damaged {
            timer.update(Time.time)
        }else{
            points.increase((points.limit * 0.5) * Time.time)
        }
    }
}
