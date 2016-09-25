//
//  Aux.swift
//  Raeximu
//
//  Created by Chris Luttio on 9/10/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

struct IndexedValue<Value: Comparable>: Comparable {
    let index: Int
    let value: Value
    
    init (_ index: Int, _ value: Value) {
        self.index = index
        self.value = value
    }
    
}

extension int2: Equatable {}
extension int2: CustomStringConvertible {
    public var description: String {
        return "\(x), \(y)"
    }
}

extension float2: CustomStringConvertible {
    public var description: String {
        return "\(x), \(y)"
    }
}

public func == (prime: int2, secunde: int2) -> Bool {
    return prime.x == secunde.x && prime.y == secunde.y
}

public func + (prime: int2, secunde: int2) -> int2 {
    return int2(prime.x + secunde.x, prime.y + secunde.y)
}

func == <Value: Comparable> (prime: IndexedValue<Value>, secunde: IndexedValue<Value>) -> Bool {
    return prime.value == secunde.value
}

func > <Value: Comparable> (prime: IndexedValue<Value>, secunde: IndexedValue<Value>) -> Bool {
    return prime.value > secunde.value
}

func >= <Value: Comparable> (prime: IndexedValue<Value>, secunde: IndexedValue<Value>) -> Bool {
    return prime.value >= secunde.value
}

func < <Value: Comparable> (prime: IndexedValue<Value>, secunde: IndexedValue<Value>) -> Bool {
    return prime.value < secunde.value
}

func <= <Value: Comparable> (prime: IndexedValue<Value>, secunde: IndexedValue<Value>) -> Bool {
    return prime.value <= secunde.value
}

extension float2: Equatable {
    func GLKVector () -> GLKVector2 {
        return GLKVector2Make(self.x, self.y)
    }
    
    var asInt2: int2 {
        return int2 (Int32(self.x), Int32(self.y))
    }
    
    static func polar (_ angle: Float) -> float2 {
        return float2(cosf(angle), sinf(angle))
    }
    
    func isGreaterThan (_ vector: float2) -> Bool {
        return length_squared(self) > length_squared(vector)
    }
    
    init (_ vec: GLKVector2) {
        self.init(vec.x, vec.y)
    }
    
    var length: Float {
        return sqrt(x * x + y * y)
    }
}

extension Collection where Iterator.Element == float2, Index == Int, IndexDistance == Int {
    var center: float2 {
        var sum = float2()
        for vec in self {
            sum += vec
        }
        return sum / Float(self.count)
    }
}

extension Collection where Iterator.Element == Int, Index == Int, IndexDistance == Int {
    func getValue(at: Int) -> Iterator.Element? {
        if at < count {
            return self[at]
        }
        return nil
    }
}

extension MutableCollection where Iterator.Element == float2, Index == Int, IndexDistance == Int {
    var centered: Self {
        var array = self
        let cen = center
        for i in 0 ..< count {
            array[i].x -= cen.x
            array[i].y -= cen.y
        }
        return array
    }
}

public func == (alpha: float2, beta: float2) -> Bool {
    return alpha.x == beta.x && alpha.y == beta.y
}

extension Float {
    
    static func random () -> Float {
        return Float ((arc4random() % 1000) / 1000)
    }
    
    static var zero: Float {
        get {
            return 0
        }
    }
    
}

extension Int: Measureable {
    
    var toRadians: Float {
        return Float(self) * Float(M_PI / 180)
    }
    
    func loop (_ block: (Int) -> ()) {
        for index in 0 ..< self {
            block(index)
        }
    }
    
    func cycle (_ block: () -> ()) {
        for _ in 0 ..< self {
            block()
        }
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    
}

extension Double: Measureable {
    func toFloat() -> Float {
        return Float(self)
    }
}

protocol Measureable {
    func toFloat() -> Float
}

extension Measureable {
    var m: Float { return self.toFloat() * 300 }
    var dm: Float { return self.m / 10 }
}

extension Array {
    
    func pair() -> [float2] {
        var array: [float2] = []
        for n in 0 ..< count / 2 {
            if let x = self[n * 2] as? Float, let y = self[n * 2 + 1] as? Float {
                 array.append(float2(x, y))
            }
        }
        return array
    }
    
}

extension Array {
    
    func asData() -> UnsafeMutablePointer<Element> {
        let pointer = UnsafeMutablePointer<Element>.allocate(capacity: self.count)
        pointer.initialize(from: self)
        return pointer
    }
    
    func asArray () -> [Float] {
        var array = [Float] ()
        for vertex in self {
            if let vertex = vertex as? float2 {
                array.append(vertex.x)
                array.append(vertex.y)
            }
        }
        return array
    }
    
    func asFloatData () -> UnsafeMutablePointer<Float> {
        return asArray().asData()
    }
    
    func rotate (_ amount: Int) -> Array {
        var array = Array(self)
        let count = abs(amount)
        let direction = amount / count
        for _ in 0..<count {
            array.insert(direction == 1 ? array.removeLast() : array.removeFirst(), at: direction == 1 ? 0 : array.count)
        }
        return array
    }
    
    func match(_ start: Int = 0, _ process: (Element, Element) -> ()) {
        for i in start ..< count {
            let prime = self[i]
            for j in i + 1 ..< count {
                let secunde = self[j]
                process(prime, secunde)
            }
        }
    }
    
    func matchIndices(_ start: Int = 0, _ process: (Int, Int) -> ()) {
        for i in start ..< count {
            for j in i + 1 ..< count {
                process(i, j)
            }
        }
    }
    
    func next(_ index: Int) -> Element {
        return self[index % count]
    }
    
}

func randomFloat () -> Float {
    return Float(arc4random() % 10000) / 10000
}

func random(_ min: Float, _ max: Float) -> Float {
    return randomFloat() * (max - min) + min
}

func << <T> (array: Array<T>, amount: Int) -> Array<T> {
    return array.rotate(-amount)
}

func >> <T> (array: Array<T>, amount: Int) -> Array<T> {
    return array.rotate(amount)
}

func normalize_safe (_ value: float2) -> float2? {
    return length_squared(value) == 0 ? nil : normalize(value)
}

extension Float {
    
    func toRadians () -> Float {
        return self * Float (M_PI / 180)
    }
    
    func toDegrees () -> Float {
        return (self * Float (180 / M_PI))
    }
    
    var isPositive: Bool {
        return self > 0
    }
    
    var isNegative: Bool {
        return self < 0
    }
    
}

infix operator ++% {
    associativity left
    precedence 150
    assignment
}

func ++% (value: inout Int, length: Int) -> Int {
    value = (value + 1) % length
    return value
}

func ++% (value: inout Float, length: Float) -> Float {
    value = (value + 1).truncatingRemainder(dividingBy: length)
    return value
}

func findBest <V: Comparable, T: Sequence> (_ range: T, _ initialValue: V, _ operation: (V, V) -> Bool, _ process: (Int) -> V) -> IndexedValue<V>? where T.Iterator.Element == Int {
    var best = IndexedValue<V>(0, initialValue)
    for index in range {
        let result = process(index)
        if result == initialValue { return nil }
        if operation(result, best.value) {
            best = IndexedValue(index, result)
        }
    }
    return best
}

func findBestValue <V: Comparable, T: Sequence> (_ range: T, _ initialValue: V, _ operation: (V, V) -> Bool, _ process: (Int) -> V) -> V? where T.Iterator.Element == Int {
    guard let value = findBest(range, initialValue, operation, process) else { return nil }
    return value.value
}

func findBestIndex <V: Comparable, T: Sequence> (_ range: T, _ initialValue: V, _ operation: (V, V) -> Bool, _ process: (Int) -> V) -> Int? where T.Iterator.Element == Int {
    guard let value = findBest(range, initialValue, operation, process) else { return nil }
    return value.index
}

func nextIndex (_ index: Int, _ count: Int) -> Int {
    return index + 1 >= count ? 0 : index + 1
}

func alpha (_ primary: Float, _ secondary: Float) -> Float {
    return primary / (primary - secondary)
}

func / (vector: float2, scalar: Float) -> float2 {
    return float2 (vector.x / scalar, vector.y / scalar)
}

func clamp <T: Comparable> (_ x: T, min: T, max: T) -> T {
    if x < min {
        return min
    }else if x > max {
        return max
    }
    return x
}

func sqr (_ num: Float) -> Float {
    return num * num
}

func length (_ x: Float, _ y: Float) -> Float {
    return sqrt(sqr(x) + sqr(y))
}

func length (_ m: Float) -> Float {
    return length(m, m)
}

func BiasGreaterThan(_ a: Float, _ b: Float) -> Bool {
    let k_biasRelative = Float(0.95);
    let k_biasAbsolute = Float(0.01);
    
    // >= instead of > for NaN comparison safety
    return a >= b * k_biasRelative + a * k_biasAbsolute;
}

func crossf2f(_ a: float2, _ b: Float) -> float2 {
    return float2 (b * a.y, -b * a.x)
}

func crossff2(_ a: Float, _ b: float2) -> float2 {
    return float2 (-a * b.y, a * b.x)
}

func equal (_ p: Float, _ s: Float) -> Bool {
    return abs(p - s) <= FLT_EPSILON
}
