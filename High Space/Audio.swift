//
//  Audio.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 12/11/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol AudioElement {
    
}

class Audio: AudioElement {
    
    let rawAudio: RawAudio
    var loop: Bool = false
    
    init(_ name: String) {
        self.rawAudio = AudioLibrary.getAudio(name)
    }
    
    static func start(_ name: String, _ mult: Float = 1) {
        let audio = Audio(name)
        audio.volume = sound_volume * mult
        audio.start()
    }
    
    static func play(_ name: String, _ volume: Float = 1) {
        let audio = Audio(name)
        audio.volume = volume
        audio.start()
    }
    
    static func stop(_ name: String) {
        Audio(name).stop()
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

@objc class RawAudio: NSObject {
    
    @objc let source, buffer: UInt32
    fileprivate(set) var volume, pitch: Float
    
    @objc init (_ source: UInt32, _ buffer: UInt32) {
        self.source = source
        self.buffer = buffer
        volume = 1
        pitch = 1
        super.init()
    }
    
    func start (_ looping: Bool = false) {
        alSourcei(source, AL_LOOPING, looping ? 1 : 0)
        alSourcePlay(source)
    }
    
    @objc func stop () {
        alSourceStop(source)
    }
  
    @objc func newVolume(_ volume: Float) {
        alSourcef(source, AL_GAIN, volume)
        self.volume = volume
    }
    
    func newPitch(_ pitch: Float) {
        alSourcef(source, AL_PITCH, pitch)
        self.pitch = pitch
    }
    
    func isPlaying () -> Bool {
        let value = UnsafeMutablePointer<ALint>.allocate(capacity: 1)
        defer {
            value.deinitialize(count: 1)
            value.deallocate()
        }
        alGetSourcei(source, AL_SOURCE_STATE, value)
        return value.pointee == AL_PLAYING
    }
    
}
