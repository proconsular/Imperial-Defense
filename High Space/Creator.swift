//
//  Creator.swift
//  Raeximu
//
//  Created by Chris Luttio on 11/14/15.
//  Copyright © 2015 FishyTale Digital, Inc. All rights reserved.
//

import Foundation

extension Physical {
    
    var index: Int {
        return Int(getBody().location.x / Piece.width)
    }
    
}

extension Array {
    
    func containsIndex(index: Int) -> Bool {
        return index >= 0 && index < count
    }
    
}

class RotatingArray<Element> {
    
    let limit: Int
    private(set) var array: [Element]
    
    private var index: Int
    var count: Int = 0
    
    var previous: Element { return get(index - 1) }
    var next: Element { return get(index + 1) }
    var current: Element { return get(index) }
    
    init (_ limit: Int) {
        self.limit = limit
        array = []
        index = 0
    }
    
    private func get(index: Int) -> Element {
        var i = index
        if index < 0 { i += limit }
        return array[i % limit]
    }
    
    func isLegal (index: Int) -> Bool {
        return index >= count - limit && index < count
    }
    
    func getLegal (index: Int) -> Element? {
        guard isLegal(index) else { return nil }
        return self[index]
    }
    
    func getRange (range: Range<Int>) -> [Element] {
        var elements: [Element] = []
        for i in range {
            if let legal = getLegal(i) {
                elements.append(legal)
            }
        }
        return elements
    }
    
    subscript(index: Int) -> Element {
        get { return array[index % limit] }
        set { array[index % limit] = newValue; count += 1 }
    }
    
    func append(item: Element) {
        if count < limit {
            array.append(item)
        }else{
            array[index ++% limit] = item
        }
        count += 1
    }
    
    func foreach (block: (Element) -> ()) {
        array.forEach(block)
    }
    
}

class Terrain: RotatingArray<Piece> {
    
    override init(_ limit: Int) {
        super.init(limit)
    }
    
    func render() {
        foreach {
            guard Camera.containsPiece($0) else { return }
            $0.display()
        }
    }
    
    var all: [Physical] {
        var objects: [Physical] = []
        for piece in array {
            objects.appendContentsOf(piece.objects)
        }
        return objects
    }
    
}

class Piece {
    
    static let width: Float = 16.m
    
    static func getLength (index: Int) -> Float {
        return Float(index) * width
    }
    
    let index: Int
    var objects: [Physical]
    var platforms: [Platform] { return objects.filter{ $0 is Platform }.map{ $0 as! Platform } }
    var isEmpty: Bool { return objects.isEmpty }
    
    var distance: Float { return Piece.getLength(index) }
    
    init (_ index: Int) {
        self.index = index
        objects = []
    }
    
    func contains (object: Physical) -> Bool {
        return object.index == index
    }
    
    func append (object: Physical) {
        objects.append(object)
    }
    
    func appendAll (all: [Physical]) {
        objects.appendContentsOf(all)
    }
    
    func display () {
        objects.forEach{
            guard Camera.contains($0.getBody().shape.getBounds()) else { return }
            $0.display()
        }
    }
    
    func enumerate() -> EnumerateSequence<[Physical]> {
        return objects.enumerate()
    }
    
}

class TerrainFabricator: SavingProducer<Floor> {
    
    let color: float4
    let size: float2
    
    init (_ size: float2, _ color: float4) {
        self.size = size
        self.color = color
    }
    
    override func create () -> [Floor]? {
        let newTerrain = Floor(float2(size.x / 2, -size.y / 2), size, color)// + float4(Float(random() % 1000) / 1000) * 0.5)
        if let last = previous?.first {
            newTerrain.body.location.x = last.body.location.x + size.x
        }
        return [newTerrain]
    }
    
}

protocol Creator: class {
    var offset: float2 { get set }
    func produce() -> [Physical]?
}

class Producer<Product> {
    
    var advocates: [Advocate<Product>] = []
    var extensions: [Extension<Product>] = []
    
    func assign (advocate: Advocate<Product>) {
        advocate.factory = self
        advocates.append(advocate)
    }
    
    func assign(ext: Extension<Product>) {
        ext.factory = self
        extensions.append(ext)
    }
    
    func generate () -> [Product]? {
        decide()
        return store(create())
    }
    
    func store(objects: [Product]?) -> [Product]? {
        save(objects)
        return objects
    }
    
    func save(objects: [Product]?) {}
    
    private func decide() {
        advocates.forEach{$0.act()}
    }
    
    private func addExtensions(objects: [Product]) -> [Physical] {
        var added: [Physical] = []
        for ext in extensions {
            ext.items = objects
            added.appendContentsOf(ext.produce()!)
        }
        return added
    }
    
    func create() -> [Product]? {
        return nil
    }
    
    func reset() {}
    
}

class PhysicalProducer<Product>: Producer<Product>, Creator {
    var offset = float2()
    
    func produce() -> [Physical]? {
        guard let items = generate() else { return nil }
        return items.map{$0 as! Physical} + addExtensions(items)
    }
}

class SavingProducer<Product>: PhysicalProducer<Product> {
    var previous: [Product]?
    
    override func save(objects: [Product]?) {
        previous = objects
    }
}

class ProceduralProducer<Product>: SavingProducer<Product> {
    
    
    
}

protocol Addon: class {
    associatedtype Product
    weak var factory: Producer<Product>! { get set }
}

class Extension<Product>: PhysicalProducer<Physical>, Addon {
    
    weak var factory: Producer<Product>!
    
    var items: [Product] = []
    
    final override func create () -> [Physical]? {
        var extendedItems: [Physical] = []
        for item in items {
            if let appendableItem = useItem(item) {
                extendedItems.appendContentsOf(appendableItem)
            }
        }
        return extendedItems
    }
    
    func useItem (item: Product) -> [Physical]? {
        return nil
    }
    
}

class Advocate<Product>: Addon {
    weak var factory: Producer<Product>!
    func act() {}
}

class PrincipalAdvocate: Advocate<Platform> {
    
    let principalReach: Float = -600
    unowned let principal: Principal
    unowned let pieces: RotatingArray<Piece>
    
    var wasPulledDown = false
    
    init (_ principal: Principal, _ pieces: RotatingArray<Piece>) {
        self.principal = principal
        self.pieces = pieces
    }
    
    override func act() {
        if !principal.onPlatforms {
            let reachable = canReach()
            reachable.isTrue(wasPulledDown = false)
            if !reachable && !wasPulledDown {
                pulldown()
            }
        }
    }
    
    private func pulldown () {
        factory.reset()
        wasPulledDown = true
    }
    
    private func canReach () -> Bool {
        let platforms = pieces[principal.index].platforms
        guard !platforms.isEmpty else { return true }
        let lowest = findBestValue(0 ..< platforms.count, -FLT_MAX, >) { return platforms[$0].body.location.y }!
        return lowest > principalReach
    }
    
}

class Regulator {
    private var assembler: Assembler
    private var canProduce: () -> Bool
    private(set) var count: Int = 0
    private unowned var list: RotatingArray<Piece>
    private var waiting: Bool = false
    
    var length: Float { return Float(count) * Piece.width }
    
    init(_ assembler: Assembler, _ list: RotatingArray<Piece>, _ canProduce: () -> Bool){
        self.canProduce = canProduce
        self.list = list
        self.assembler = assembler
        prepare()
    }
    
    private func prepare () {
        list.limit.loop{list.append(Piece($0))}
        progress()
    }
    
    private func progress() {
        waiting = true
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { 
            let products = self.assembler.assemble(self.count)
            dispatch_sync(dispatch_get_main_queue(), { 
                products.forEach(self.assign)
                self.count += 1
                self.waiting = false
            })
        }
    }
    
    private func assign (object: Physical) {
        list.getLegal(object.index)?.append(object)
    }
    
    func regulate () {
        refresh()
        relocate()
    }
    
    private func refresh () {
        if canProduce() && !waiting {
            repurpose()
            progress()
        }
    }
    
    private func relocate () {
        for piece in list.array {
            piece.objects = piece.objects.filter {
                guard !piece.contains($0) else { return true }
                assign($0)
                return false
            }
        }
    }
    
    private func repurpose () {
        if !list[count].isEmpty {
            list[count] = Piece(count)
        }
    }
    
}

class Assembler {
    private var fabricators: [Creator]
    
    init (_ fabricators: [Creator]) {
        self.fabricators = fabricators
    }
    
    func assemble (index: Int) -> [Physical] {
        var objects: [Physical] = []
        for fabricator in fabricators {
            fabricator.offset.x = Piece.getLength(index)
            if let newObjects = fabricator.produce() {
                objects.appendContentsOf(newObjects)
            }
        }
        return objects
    }
}

class GameAssembler: Assembler {
    
    init(_ principal: Principal, _ terrain: Terrain) {
        var assemblers: [Creator] = []
        
        assemblers.append(TerrainFabricator(float2(Piece.width, 0.4.m), float4(0, 0, 0, 1)))
        
        let assembler = PlatformFabrication.Assembler(float2(Piece.width, -1.48.m), 1000.m)
        assembler.assign(PrincipalAdvocate(principal, terrain))
        assemblers.append(assembler)
        
        super.init(assemblers)
    }
    
}













