//
//  Platform.swift
//  Bot Bounce+
//
//  Created by Chris Luttio on 11/28/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

class Limit {
    let minimum, maximum, average: Float
    
    init(_ average: Float, _ minimum: Float, _ maximum: Float) {
        self.average = average
        self.minimum = minimum
        self.maximum = maximum
    }
    
    var maximum_length: Float {
        return maximum - average
    }
    
    var minimum_length: Float {
        return minimum - average
    }
    
    func selectLength(direction: Bool) -> Float {
        return direction ? maximum_length : minimum_length
    }
    
    func length(variance: Float) -> Float {
        return abs(variance) * selectLength(!variance.isSignMinus)
    }
}

class LimitedProducer: Producer<Float> {
    let limit: Limit
    
    var variance: Float
    
    init(_ limit: Limit, _ variance: Float = 0) {
        self.limit = limit
        self.variance = variance
    }
    
    override func create() -> [Float]? {
        return [limit.average + limit.length(variance)]
    }
    
}

class PlatformFabrication {
    
    struct Element {
        var horizontal, vertical, length: Float
        
        init(_ length: Float, _ horizontal: Float, _ vertical: Float) {
            self.length = length
            self.horizontal = horizontal
            self.vertical = vertical
        }
        
        var offset: float2 {
            return float2(length + horizontal, vertical)
        }
    }
    
    class PlatformProcedure: Procedure<Element, Platform> {
        
        override init(_ name: Int = 0, _ types: [Element] = []) {
            super.init(name, types)
        }
        
        override func construct(offset: float2) -> GeneratedProcedure<Platform> {
            guard name != 0 else { return GeneratedProcedure<Platform>(offset + float2(Piece.width, 0)) }
            var platforms: [Platform] = []
            
            var placement = offset
            for element in elements {
                platforms.append(Platform(placement, float2(element.length,  0.12.m)))
                placement += element.offset
            }
            
            let location = float2(platforms.last!.right + Principal.getJumpDistance(0) - 0.3.m, platforms.last!.location.y - 0.12.m / 2)
            return GeneratedProcedure<Platform>(location, platforms)
        }
        
        var bounds: float2 {
            var sum = float2()
            for e in elements {
                sum += e.offset
            }
            return sum
        }
    }
    
    class ElementProducer: Producer<Element> {
        var limiters: [LimitedProducer]
        
        let variance: Float = 5
        var count1 = 0, count2 = 0
        var permutations: Int { return Int(variance * variance) }
        
        init(_ limiters: [LimitedProducer]) {
            self.limiters = limiters
        }
        
        func computeVariance(count: Int, _ variance: Float) -> Float {
            let d = variance + 1
            let limit = d / (d - 2)
            return clamp(limit * (2 * (Float(count % Int(d - 1) + 1) / d) - 1), min: -1, max: 1)
        }
        
        override func create() -> [Element]? {
            var set: [Element] = []
            
            let length = computeLength()
            let vertical = computeVerticalSpace()
            let element = Element(length, Principal.getJumpDistance(vertical) - 0.3.m, vertical)
            
            computeAmount(length).cycle{ set.append(element) }
            increment()
            
            return set
        }
        
        private func computeLength() -> Float {
            limiters[0].variance = computeVariance(count1, variance)
            return limiters[0].generate()!.first!
        }
        
        private func computeVerticalSpace() -> Float {
            limiters[1].variance = computeVariance(count2, variance)
            return limiters[1].generate()!.first!
        }
        
        private func computeAmount(length: Float) -> Int {
            var amount = Int(random(3, 6))
            if length >= 5.m {
                amount = 1
            }
            return amount
        }
        
        private func increment() {
            count1 += 1
            if count1 % Int(variance) == 0 {
                count2 += 1
            }
        }
    }
    
    class PlatformProcedureSelector: StateDevice<Int> {
        var constraints: [float2 -> Bool] = []
        var selections: Queue<PlatformProcedure> = Queue()
        
        init(_ settings: [PlatformProcedure]) {
            super.init()
            let blank = PlatformProcedure()
            append(blank)
            settings.match{
                $0.connections.append(Link($1, 1))
                $1.connections.append(Link($0, 1))
            }
            settings.forEach{ blank.connections.append(Link($0, 1)) }
            appendAll(settings)
            set(0)
        }
        
        func select(offset: float2) -> PlatformProcedure {
            let current = find(offset)
            try! next()
            return current
        }
        
        func find(offset: float2) -> PlatformProcedure {
            var procedure = current
            constraints.filter{ $0(offset + procedure.bounds) }.forEach{ _ in procedure = retry(procedure.name, offset) }
            return procedure
        }
        
        var current: PlatformProcedure {
            return get() as! PlatformProcedure
        }
        
        func retry(name: Int, _ offset: float2) -> PlatformProcedure {
            defer { omittions.removeAll() }
            omit([name])
            try! replay()
            return find(offset)
        }
        
        func reset() {
            set(0)
        }
        
    }
    
    class Assembler: ProceduralProducer<Platform> {
        let boundary: float2
        let length: Float
        let selector: PlatformProcedureSelector
        let valve = Valve<GeneratedProcedure<Platform>>()
        
        init(_ limit: float2, _ length: Float) {
            self.length = length
            self.boundary = limit
            
            let producer = ElementProducer([LimitedProducer(Limit(2.5.m, 1.25.m, 8.m)), LimitedProducer(Limit(0.m, -1.m, 5.m))])
            
            var settings: [PlatformProcedure] = []
            for i in 0 ..< producer.permutations {
                settings.append(PlatformProcedure(i + 1, producer.generate()!))
            }
            
            selector = PlatformProcedureSelector(settings)
            
            super.init()
            valve.constraints.append({ [unowned self] in $0.offset.x <= self.offset.x + self.boundary.x })
            valve.constraints.append({ [unowned self] in $0.offset.x <= self.length })
            selector.constraints.append({ [unowned self] in $0.y > self.boundary.y })
        }
        
        override func create() -> [Platform]? {
            fill(computeLocation())
            return valve.release()?.elements
        }
        
        private func fill(location: float2) {
            valve.supply(selector.select(location).construct(location))
        }
        
        private func computeLocation() -> float2 {
            return valve.reserve?.offset ?? float2(offset.x, boundary.y)
        }
        
        private var edge: Float {
            return offset.x + boundary.x
        }
        
        override func reset() {
            valve.drain()
            selector.reset()
        }
        
    }

}
