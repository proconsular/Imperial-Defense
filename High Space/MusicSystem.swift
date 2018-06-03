//
//  AudioController.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/29/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MusicSystem {
    static var instance: MusicSystem!
    var events: [MusicEvent]
    var blended: [MusicEvent]
    
    static func create() {
        instance = MusicSystem()
    }
    
    init() {
        events = []
        blended = []
    }
    
    func update() {
        if events.count > 0 {
            let current = events.first!
            if !current.wasPlayed {
                current.play()
            }
            if !current.playing {
                if current.loop {
                    current.play()
                }else{
                    events.removeFirst()
                    if let next = events.first {
                        next.play()
                    }
                }
            }
        }
        if !blended.isEmpty {
            let current = blended.first!
            current.volume -= (4 * Time.delta)
            if current.volume <= 0 {
                current.stop()
                blended.removeFirst()
            }
        }
    }
    
    func append(_ event: MusicEvent) {
        events.append(event)
    }
    
    func interrupt() {
        if !events.isEmpty {
            blended.append(events.removeFirst())
        }
    }
    
    func flush() {
        interrupt()
        events.removeAll()
    }
}
