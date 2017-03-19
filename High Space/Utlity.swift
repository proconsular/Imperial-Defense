//
//  Timer.swift
//  Raeximu
//
//  Created by Chris Luttio on 10/24/15.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

func play(_ name: String, _ pitch: Float = 1) {
    let audio = Audio(name)
    audio.pitch = pitch
    audio.start()
}

func playIfNot(_ name: String, _ pitch: Float = 1) {
    let audio = Audio(name)
    if !audio.playing {
        audio.pitch = pitch
        audio.start()
    }
}

func count (_ increment: inout Float, _ amount: Float, _ rate: Float, _ execution: @autoclosure () -> ()) {
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
    
    init (_ rate: Float, _ event: @escaping () -> ()) {
        self.rate = rate
        self.event = event
        increment = 0
    }
    
    mutating func update (_ amount: Float) {
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
        startTime = CACurrentMediaTime()
    }
    
    func process (_ frameTime: Double, _ step: @autoclosure () -> ()) {
        deltaTime = clamp(deltaTime + computePastTime(), min: 0, max: limit)
        
        let frames = Int(computeFrames(frameTime))
        frames.cycle(step)
        
        deltaTime -= frameTime * Double(frames)
        remainder = computeFrames(frameTime)
    }
    
    func computeFrames(_ frameTime: Double) -> Double {
        return deltaTime / frameTime
    }
    
    func getRemainder () -> Double {
        return remainder
    }
    
    func computePastTime () -> Double {
        let currentTime = CACurrentMediaTime()
        let time = currentTime - startTime
        startTime = currentTime
        return time
    }
    
}

class Queue<Element> {
    fileprivate var array: [Element] = []
    var isEmpty: Bool { return array.isEmpty }
    
    func push (_ element: Element) {
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
