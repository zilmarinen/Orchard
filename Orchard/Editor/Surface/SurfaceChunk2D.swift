//
//  SurfaceChunk2D.swift
//  Orchard
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class SurfaceChunk2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tiles
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public let bounds: GridBounds
    var tiles: [SurfaceTile2D] = []
    
    required init(coordinate: Coordinate) {
            
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        bounds = GridBounds(aligned: coordinate, size: World.Constants.chunkSize)
        tiles = try container.decode([SurfaceTile2D].self, forKey: .tiles)
        
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
}

extension SurfaceChunk2D {
    
    func add(tile coordinate: Coordinate) -> SurfaceTile2D? {

        guard find(tile: coordinate) == nil else { return nil }

        let tile = SurfaceTile2D(coordinate: coordinate)

        tiles.append(tile)

        addChild(tile)

        becomeDirty()

        return tile
    }

    func find(tile coordinate: Coordinate) -> SurfaceTile2D? {

        return tiles.first { $0.coordinate.adjacency(to: coordinate) == .equal }
    }

    func remove(tile coordinate: Coordinate) {

        guard let index = tiles.firstIndex(where: { $0.coordinate.adjacency(to: coordinate) == .equal }) else { return }

        let tile = tiles[index]

        tiles.remove(at: index)

        tile.removeFromParent()

        becomeDirty()
    }
}

extension SurfaceChunk2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: self.bounds.start.x, y: self.bounds.start.z)
        
        path = CGPath(rect: CGRect(x: 0, y: 0, width: World.Constants.chunkSize, height: World.Constants.chunkSize), transform: nil)
        
        fillColor = .lightGray
        blendMode = .multiplyAlpha
        
        for tile in tiles {
            
            tile.clean()
        }
        
        isDirty = false
        
        return true
    }
}
