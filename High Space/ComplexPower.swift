//
//  ComplexPower.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/14/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class ComplexPower: UnitPower {
    var powers: [RankedPower]
    var rank: Int
    
    var selectedPower: UnitPower?
    
    init() {
        rank = 0
        powers = []
    }
    
    var cost: Float {
        return selectedPower?.cost ?? 0
    }
    
    func set(_ rank: Int) {
        selectedPower = find(rank)
    }
    
    func append(_ rank: Int, _ power: UnitPower) {
        powers.append(RankedPower(rank, power))
    }
    
    func isAvailable(_ power: Float) -> Bool {
        return selectedPower?.isAvailable(power) ?? false
    }
    
    func invoke() {
        selectedPower?.invoke()
    }
    
    func find(_ rank: Int) -> UnitPower? {
        var select: [RankedPower] = []
        for ranked in powers {
            if ranked.rank == rank {
                select.append(ranked)
            }
        }
        if select.isEmpty { return nil }
        return select[randomInt(0, select.count)].power
    }
    
    func update() {
        for ranked in powers {
            ranked.power.update()
        }
    }
}
