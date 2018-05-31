//
//  LaserAudio.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 5/30/18.
//  Copyright © 2018 Storiel, LLC. All rights reserved.
//

import Foundation

class LaserAudio: AudioDelegate {
    unowned let laser: Laser
    let sound: String
    
    init(_ laser: Laser, _ sound: String) {
        self.laser = laser
        self.sound = sound
    }
    
    func play() {
        if laser.visible {
            if laser.display.color.w == 1 {
                if !Audio(sound).playing {
                    Audio.play(sound, 0.5)
                }
            }
        }
    }
}
