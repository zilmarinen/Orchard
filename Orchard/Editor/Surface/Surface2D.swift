//
//  Surface2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Meadow
import SpriteKit

class Surface2D: Grid2D<SurfaceChunk2D, SurfaceTile2D> {
    
    enum Overlay {
        
        case edge
        case elevation
        case material
    }
    
    struct Tilemap {
        
        let tileset: [String : SKTexture]
        let shader = SKShader(shader: .surface)
        
        init() {
        
            guard let tilemap = try? SurfaceTilemap() else { fatalError("Error loading surface tilemap") }
            
            var textures: [String : SKTexture] = [:]
            
            for tile in tilemap.tileset.tiles {
                
                textures["\(tile.pattern)"] = SKTexture(image: tilemap.tileset.image(for: tile))
            }
            
            tileset = textures
            
            shader.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        }
    }
    
    let tilemap = Tilemap()
    
    var overlay: Overlay = .material {
        
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
        
        let (even, odd) = sortedTiles
        
        for tile in even {
            
            tile.collapse()
        }
        
        for tile in odd {
            
            tile.collapse()
        }
        
        return super.clean()
    }
}
