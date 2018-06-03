//
//  MusicEvent.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/29/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class MusicEvent {
    let audio: Audio
    var song: String
    var loop: Bool
    var wasPlayed: Bool
    
    init(_ song: String, _ loop: Bool = false) {
        self.song = song
        self.loop = loop
        wasPlayed = false
        audio = Audio(song)
        audio.volume = 1
    }
    
    func play() {
        audio.start()
        wasPlayed = true
    }
    
    func stop() {
        audio.stop()
    }
    
    var volume: Float {
        get { return audio.volume }
        set { audio.volume = newValue }
    }
    
    var playing: Bool {
        return Audio(song).playing
    }
}
