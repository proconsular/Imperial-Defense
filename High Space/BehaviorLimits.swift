//
//  AI.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 7/25/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class BehaviorRuleEnforcer {
    
    var rules: [BehaviorRule]
    
    init() {
        rules = []
        rules.append(RushLimitRule(6))
        rules.append(AllfireLimitRule(1.5))
    }
    
    func update() {
        rules.forEach{ $0.update() }
        process()
    }
    
    func process() {
        let queue = BehaviorQueue.instance.queue
        while !queue.isEmpty {
            let request = queue.pop()
            
            if let rule = findRule(request.id) {
                if rule.legal() {
                    request.behavior.trigger()
                }
            }
        }
    }
    
    func findRule(_ id: String) -> BehaviorRule? {
        for rule in rules {
            if rule.id == id {
                return rule
            }
        }
        return nil
    }
    
}
