//
//  Surface2D.swift
//  Orchard
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class Surface2D: SKNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case chunks
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var chunks: [SurfaceChunk2D] = []
    
    var tiles: [SurfaceTile2D] { chunks.flatMap { $0.tiles } }
    
    var showElevation: Bool = false {
        
        didSet {
            
            tiles.forEach { tile in
                
                tile.label.isHidden = !showElevation
            }
        }
    }
    
    override init() {
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([SurfaceChunk2D].self, forKey: .chunks)
        
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
}

extension Surface2D {
    
    public typealias TileConfiguration = ((SurfaceTile2D) -> Void)
        
    public func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> SurfaceTile2D? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let chunk = find(chunk: coordinate) ?? SurfaceChunk2D(coordinate: coordinate)
        
        guard let tile = chunk.add(tile: coordinate) else { return nil }
        
        if chunk.parent == nil {
            
            chunks.append(chunk)
            
            addChild(chunk)
        }
        
        setupNeighbours(for: tile)
        
        configure?(tile)
        
        becomeDirty()
        
        return tile
    }
    
    public func find(tile coordinate: Coordinate) -> SurfaceTile2D? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    func find(chunk coordinate: Coordinate) -> SurfaceChunk2D? {
        
        return chunks.first { $0.bounds.contains(coordinate: coordinate) }
    }
    
    public func remove(tile coordinate: Coordinate) {
            
        guard let chunk = find(chunk: coordinate) else { return }
        
        chunk.remove(tile: coordinate)
        
        guard chunk.tiles.isEmpty,
              let index = chunks.firstIndex(of: chunk) else { return }
        
        chunks.remove(at: index)
        
        chunk.removeFromParent()
        
        becomeDirty()
    }
    
    func setupNeighbours(for tile: SurfaceTile2D) {
        
        for cardinal in Cardinal.allCases {
         
            if let neighbour = find(tile: tile.coordinate + cardinal.coordinate) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
    }
}

extension Surface2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //TODO: collapse tiles
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}
