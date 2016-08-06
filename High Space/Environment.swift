//
//  Environment.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/13/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

protocol AudioElement: class {
    var volume: Float { get set }
    var loop: Bool { get set }
    
    func start()
    func stop()
    func tick()
}

class AudioDevice: AudioElement {
    
    var audio: [AudioElement]
    var volume: Float
    var loop = false
    
    init(_ audio: [AudioElement]) {
        self.volume = 1
        self.audio = audio
    }
    
    func start() {
        audio.forEach{$0.start()}
    }
    
    func stop() {
        audio.forEach{$0.stop()}
    }
    
    func tick() {
        audio.forEach{$0.tick()}
    }
    
}

class GameAudio: AudioDevice {
    
    init(_ volume: Float, _ names: [String]) {
        super.init(names.map{Audio($0)})
        self.volume = volume
        audio.forEach{$0.volume = volume}
    }
    
    deinit {
        stop()
    }
    
}

class ThemeAudio: GameAudio {
    
    var playingIntro = true
    
    init (volume: Float) {
        super.init(volume, ["ThemeIntro", "ThemeLoop"])
    }
    
    override func start() {
        audio.first!.start()
    }
    
    override func tick() {
        if playingIntro {
            if !AudioLibrary.getAudio("ThemeIntro").isPlaying() {
                playMusic("ThemeLoop", true)
                playingIntro = false
            }
        }
    }
    
}

class HoverAudio: GameAudio {
    
    unowned let principal: Principal
    unowned let pieces: RotatingArray<Piece>
    
    init(volume: Float, _ principal: Principal, _ pieces: RotatingArray<Piece>) {
        self.principal = principal
        self.pieces = pieces
        super.init(volume, ["hover"])
    }
    
    override func start() {
        audio.first!.loop = true
        audio.first!.start()
    }
    
    override func tick() {
        audio.first!.volume = computeVolume()
    }
    
    private func computeVolume () -> Float {
        let count = 4
        let index = principal.index - count / 2
        let ranged = pieces.getRange(index ..< index + count)
        
        guard let closest = closestPiece(ranged) else { return 0 }
        
        let attentuation = (length(Camera.size) / closest) / 20
        return clamp(attentuation, min: 0, max: 1) * volume
    }
    
    private func closestPiece (pieces: [Piece]) -> Float? {
        var closest = FLT_MAX
        
        for piece in pieces {
            let value = closestPlatform(piece)
            if value < closest {
                closest = value
            }
        }
        
        return closest == FLT_MAX ? nil : closest
    }
    
    private func closestPlatform (piece: Piece) -> Float {
        let platforms = piece.platforms
        return findBestValue(0 ..< platforms.count, FLT_MAX, <) { [unowned self] in
            return self.distance(platforms[$0])
        }!
    }
    
    private func distance(platform: Platform) -> Float {
        return abs(length(principal.body.location - platform.body.location))
    }
    
}

class AmbientAudio: GameAudio {
    
    init(volume: Float, _ name: String) {
        super.init(volume, [name])
    }
    
    override func start() {
        audio.first!.loop = true
        audio.first!.start()
    }
    
}

class AudioEnvironment: AudioDevice {
    
    let level: String
    
    init (_ name: String, _ principal: Principal, _ pieces: RotatingArray<Piece>) {
        level = name
        loadMusic(name)
        super.init([
            ThemeAudio(volume: 0.4),
            HoverAudio(volume: 0.6, principal, pieces),
            AmbientAudio(volume: 0.2, name)
        ])
    }
    
    deinit {
        stop()
        unloadMusic(level)
    }
    
}