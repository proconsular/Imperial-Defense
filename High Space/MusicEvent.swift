//
//  MusicEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/29/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MusicEvent {
    var song: String
    var loop: Bool
    var wasPlayed: Bool
    
    init(_ song: String, _ loop: Bool = false) {
        self.song = song
        self.loop = loop
        wasPlayed = false
    }
    
    func play() {
        Audio.play(song, 1)
        wasPlayed = true
    }
    
    func stop() {
        Audio.stop(song)
    }
    
    var playing: Bool {
        return Audio(song).playing
    }
}
