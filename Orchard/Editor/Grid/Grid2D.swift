//
//  Grid2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

class Grid2D<C: Chunk2D<T>, T: Tile2D>: SKNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case chunks = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var chunks: [C] = []
    
    override init() {
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([C].self, forKey: .chunks)
        
        super.init()
        
        for chunk in chunks {
            
            for tile in chunk.tiles {
                
                setupNeighbours(for: tile)
            }
            
            addChild(chunk)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks, forKey: .chunks)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
    
    typealias TileConfiguration = ((T) -> Void)
        
    func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> T? {
        
        if let tile = find(tile: coordinate) {
            
            configure?(tile)
            
            becomeDirty()
            
            return tile
        }
        
        let chunk = find(chunk: coordinate) ?? C(coordinate: coordinate)
        
        let tile = chunk.add(tile: coordinate)
        
        if chunk.parent == nil {
            
            chunks.append(chunk)
            
            addChild(chunk)
        }
        
        setupNeighbours(for: tile)
        
        configure?(tile)
        
        becomeDirty()
        
        return tile
    }
}

extension Grid2D {
    
    var tiles: [T] { chunks.flatMap { $0.tiles } }
    
    var sortedTiles: (even: [T], odd: [T]) {
        
        var even: [T] = []
        var odd: [T] = []
        
        for tile in tiles {
            
            if (abs(tile.coordinate.x) + abs(tile.coordinate.z)) % 2 == 0 {
                
                even.append(tile)
            }
            else {
                
                odd.append(tile)
            }
        }
        
        even.sort { (lhs, rhs) -> Bool in
            
            lhs.coordinate.y > rhs.coordinate.y
        }
        
        odd.sort { (lhs, rhs) -> Bool in
            
            lhs.coordinate.y > rhs.coordinate.y
        }
        
        return (even, odd)
    }
}

extension Grid2D {
    
    func find(tile coordinate: Coordinate) -> T? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    func find(chunk coordinate: Coordinate) -> C? {
        
        return chunks.first { $0.bounds.contains(coordinate: coordinate) }
    }
    
    func remove(tile coordinate: Coordinate) {
            
        guard let chunk = find(chunk: coordinate) else { return }
        
        chunk.remove(tile: coordinate)
        
        guard chunk.tiles.isEmpty,
              let index = chunks.firstIndex(of: chunk) else { return }
        
        chunks.remove(at: index)
        
        chunk.removeFromParent()
        
        becomeDirty()
    }
    
    func setupNeighbours(for tile: T) {
        
        for cardinal in Cardinal.allCases {
         
            if let neighbour = find(tile: tile.coordinate + cardinal.coordinate) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
    }
}
