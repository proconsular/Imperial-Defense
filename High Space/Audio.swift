//
//  Audio.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 12/11/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Audio: AudioElement {
    
    let rawAudio: RawAudio
    var loop: Bool = false
    
    init(_ name: String) {
        self.rawAudio = AudioLibrary.getAudio(name)
    }
    
    func start() {
        rawAudio.start(loop)
    }
    
    func stop() {
        rawAudio.stop()
    }
    
    func tick() {
        
    }
    
    var playing: Bool {
        get { return rawAudio.isPlaying() }
    }
    
    var volume: Float {
        get { return rawAudio.volume }
        set { rawAudio.newVolume(newValue) }
    }
    
    var pitch: Float {
        get { return rawAudio.pitch }
        set { rawAudio.newPitch(newValue) }
    }
    
}

@objc
class RawAudio: NSObject {
    
    let source, buffer: UInt32
    private(set) var volume, pitch: Float
    
    init (_ source: UInt32, _ buffer: UInt32) {
        self.source = source
        self.buffer = buffer
        volume = 1
        pitch = 1
        super.init()
    }
    
    func start (looping: Bool = false) {
        alSourcei(source, AL_LOOPING, looping ? 1 : 0)
        alSourcePlay(source)
    }
    
    func stop () {
        alSourceStop(source)
    }
  
    func newVolume(volume: Float) {
        alSourcef(source, AL_GAIN, volume)
        self.volume = volume
    }
    
    func newPitch(pitch: Float) {
        alSourcef(source, AL_PITCH, pitch)
        self.pitch = pitch
    }
    
    func isPlaying () -> Bool {
        let value = UnsafeMutablePointer<ALint>.alloc(1)
        defer { value.destroy(); value.dealloc(1) }
        alGetSourcei(source, AL_SOURCE_STATE, value)
        return value.memory == AL_PLAYING
    }
    
}