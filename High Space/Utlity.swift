//
//  Timer.swift
//  Raeximu
//
//  Created by Chris Luttio on 10/24/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation


func getDescription (name: String) -> Texture {
    return TextureRepo.sharedLibrary().descriptionWithName(name)
}

func getTexture (name: String) -> GLuint {
    return TextureRepo.sharedLibrary().textureWithName(name)
}

enum Quality {
    case Low, High
}

func deleteTexture (name: String) {
    TextureRepo.deleteTexture(name)
}

func loadTexture (name: String) -> GLuint {
    return loadTexture(name, quality: .High)
}

func loadTexture (name: String, quality: Quality) -> GLuint {
    TextureRepo.sharedLibrary().prefetch(name)
    let des = TextureRepo.sharedLibrary().textures[name] as! Texture
    return des.texture
}

func playSound (name: String) {
    AudioLibrary.getAudio(name).start()
}

func stopSound (name: String) {
    AudioLibrary.getAudio(name).stop()
}

func getSound (name: String) -> Audio {
    return Audio(name)
}

func playSound (name: String, _ gain: Float) {
    let sound = AudioLibrary.getAudio(name)
    sound.newVolume(gain)
    sound.start()
}

func playMusic (name: String, _ looping: Bool) {
    AudioLibrary.getAudio(name).start(looping)
}

func loadMusic (name: String) {
    AudioLibrary.sharedLibrary().loadMusicWithName(name)
}

func unloadMusic (name: String) {
    AudioLibrary.sharedLibrary().unloadMusicWithName(name)
}

func count (inout increment: Float, _ amount: Float, _ rate: Float, @autoclosure _ execution: () -> ()) {
    increment += amount
    if increment >= rate {
        increment = 0
        execution()
    }
}

struct Timer {
    let rate: Float
    var increment: Float
    var event: () -> ()
    
    init (_ rate: Float, _ event: () -> ()) {
        self.rate = rate
        self.event = event
        increment = 0
    }
    
    mutating func update (amount: Float) {
        count(&increment, amount, rate, event())
    }
}

class Processor {
    
    private let limit: Double
    
    private var startTime, deltaTime: Double
    private var remainder: Double
    
    init (_ limit: Double) {
        self.limit = limit
        deltaTime = 0
        remainder = 0
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func process (frameTime: Double, @autoclosure _ step: () -> ()) {
        deltaTime = clamp(deltaTime + computePastTime(), min: 0, max: limit)
        
        let frames = Int(computeFrames(frameTime))
        frames.cycle(step)
        
        deltaTime -= frameTime * Double(frames)
        remainder = computeFrames(frameTime)
    }
    
    func computeFrames(frameTime: Double) -> Double {
        return deltaTime / frameTime
    }
    
    func getRemainder () -> Double {
        return remainder
    }
    
    func computePastTime () -> Double {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let time = currentTime - startTime
        startTime = currentTime
        return time
    }
    
}

class Queue<Element> {
    private var array: [Element] = []
    var isEmpty: Bool { return array.isEmpty }
    
    func push (element: Element) {
        array.append(element)
    }
    
    func pop () -> Element {
        return array.removeFirst()
    }
    
    func clear () {
        array.removeAll()
    }
    
    var peek: Element? {
        return array.first
    }
    
    var peer: Element? {
        return array.last
    }
    
}