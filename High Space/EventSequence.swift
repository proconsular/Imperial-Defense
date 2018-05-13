//
//  EventList.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 11/26/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

class EventSequence {
    var queue: Queue<GameEvent>
    var event: GameEvent?
    
    init() {
        queue = Queue<GameEvent>()
    }
    
    func append(_ event: GameEvent) {
        queue.push(event)
    }
    
    func update() {
        if let event = event {
            if event.complete {
                self.event = nil
            }
        }
        
        if event == nil {
            if !queue.isEmpty {
                let newEvent = queue.pop()
                newEvent.activate()
                event = newEvent
            }
        }
        
        if let element = event as? GameElement {
            element.update()
        }
    }
    
    func use(_ command: Command) {
        if let layer = event as? GameLayer {
            layer.use(command)
        }
    }
    
    func render() {
        if let layer = event as? GameLayer {
            layer.render()
        }
    }
}
