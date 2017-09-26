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

protocol BehaviorRule {
    var id: String { get set }
    func legal() -> Bool
    func update()
}

class RushLimitRule: BehaviorRule {
    var id = "rush"
    var counter: Float = 0
    let rate: Float
    
    init(_ rate: Float) {
        self.rate = rate
    }
    
    func legal() -> Bool {
        if counter >= rate {
            counter = 0
            return true
        }
        return false
    }
    
    func update() {
        counter += Time.delta
    }
    
}

class AllfireLimitRule: BehaviorRule {
    var id = "allfire"
    var counter: Float = 0
    let rate: Float
    
    init(_ rate: Float) {
        self.rate = rate
    }
    
    func legal() -> Bool {
        if counter >= rate {
            counter = 0
            return true
        }
        return false
    }
    
    func update() {
        counter += Time.delta
    }
}

class BehaviorRequest {
    let id: String
    let behavior: TriggeredBehavior
    
    init(_ id: String, _ behavior: TriggeredBehavior) {
        self.id = id
        self.behavior = behavior
    }
}

class BehaviorQueue {
    
    static var instance: BehaviorQueue!
    
    var queue: Queue<BehaviorRequest>
    
    init() {
        queue = Queue()
    }
    
    func submit(_ request: BehaviorRequest) {
        queue.push(request)
    }
}
