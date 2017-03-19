//
//  Experimental.swift
//  Imperial Defense
//
//  Created by Chris Luttio on 2/14/17.
//  Copyright © 2017 Storiel, LLC. All rights reserved.
//

import Foundation

protocol RenderList {
    func getDisplays() -> [Display]
}

class Renderer {
    
    var list: RenderList
    
    init(_ list: RenderList) {
        self.list = list
    }
    
    func render() {
        let batches = compile().sorted{ $0.order < $1.order }
        batches.forEach{
            $0.render()
        }
    }
    
    func compile() -> [Batch] {
        let displays = list.getDisplays().sorted{ $0.texture < $1.texture }
        var batches: [Batch] = []
        var batch: Batch!
        for display in displays {
            if batch == nil {
                batch = Batch()
                batches.append(batch)
            }else{
                if let scheme = batch.group.schemes.first {
                    if scheme.texture != display.texture {
                        batch = Batch()
                        batches.append(batch)
                    }
                }
            }
            if batch.group.schemes.count > 10 {
                batch = Batch()
                batches.append(batch)
            }
            batch.append(display.scheme.schemes[0])
        }
        return batches
    }
    
}

class Stopwatch {
    private static var start: Double = 0
    private static var end: Double = 0
    
    static func begin() {
        start = CACurrentMediaTime()
        end = start
    }
    
    static func finish() {
        end = CACurrentMediaTime()
    }
    
    static var time: Double {
        return end - start
    }
    
    static func post() {
        finish()
        print(time)
    }
}









