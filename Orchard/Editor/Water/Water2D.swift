//
//  Water2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow
import SpriteKit

class Water2D: Grid2D<WaterChunk2D, WaterTile2D> {
    
    enum Overlay {
        
        case none
        case elevation
    }
    
    struct Tilemap {
        
        let tileset: [String : SKTexture]
        let shader = SKShader(shader: .water)
        
        init() {
        
            guard let tilemap = try? SurfaceTilemap() else { fatalError("Error loading water tilemap") }
            
            var textures: [String : SKTexture] = [:]
            
            for tile in tilemap.tileset.tiles {
                
                textures["\(tile.pattern)"] = SKTexture(image: tilemap.tileset.image(for: tile))
            }
            
            tileset = textures
            
            shader.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        }
    }
    
    let tilemap = Tilemap()
    
    var overlay: Overlay = .none {
        
        didSet {
            
            if oldValue != overlay {
                
                for tile in tiles {
                    
                    tile.becomeDirty()
                }
            }
        }
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        
        let (even, odd) = sortedTiles
        
        for tile in even {
            
            tile.collapse()
        }
        
        for tile in odd {
            
            tile.collapse()
        }
        
        return super.clean()
    }
    
    override func add(tile coordinate: Coordinate, configure: Grid2D<WaterChunk2D, WaterTile2D>.TileConfiguration? = nil) -> WaterTile2D? {
        
        guard let editor = ancestor as? Editor,
              let tile = editor.surface.find(tile: coordinate),
              tile.corners.values.filter({ $0 < coordinate.y }).count > 0 else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
}
