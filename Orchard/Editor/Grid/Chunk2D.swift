//
//  Chunk2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

class Chunk2D<T: Tile2D>: SKNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let bounds: GridBounds
    var tiles: [T] = []
    
    required init(coordinate: Coordinate) {
            
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        tiles = try container.decode([T].self, forKey: .tiles)
        
        super.init()
        
        for tile in tiles {
            
            addChild(tile)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bounds.start, forKey: .coordinate)
        try container.encode(tiles, forKey: .tiles)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: bounds.start.x, y: bounds.start.z)
        
        for tile in tiles {
            
            tile.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Chunk2D {
    
    func add(tile coordinate: Coordinate) -> T {

        if let tile = find(tile: coordinate) {
            
            becomeDirty()
            
            return tile
        }

        let tile = T(coordinate: coordinate)

        tiles.append(tile)

        addChild(tile)

        becomeDirty()

        return tile
    }

    func find(tile coordinate: Coordinate) -> T? {

        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }

    func remove(tile coordinate: Coordinate) {

        guard let index = tiles.firstIndex(where: { $0.coordinate.adjacency(to: coordinate) == .equal }) else { return }

        let tile = tiles[index]
        
        for cardinal in Cardinal.allCases {
            
            tile.remove(neighbour: cardinal)
        }

        tiles.remove(at: index)

        tile.removeFromParent()

        becomeDirty()
    }
}
