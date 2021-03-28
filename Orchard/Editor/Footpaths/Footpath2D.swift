//
//  Footpath2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

class Footpath2D: Grid2D<FootpathChunk2D, FootpathTile2D> {
    
    struct Tilemap {
        
        let tileset: [String : SKTexture]
        let shader = SKShader(fileNamed: "Footpath2D.fsh")
        
        init() {
        
            guard let tilemap = try? FootpathTilemap() else { fatalError("Error loading surface tilemap") }
            
            var textures: [String : SKTexture] = [:]
            
            for tile in tilemap.tileset.tiles {
                
                textures["\(tile.pattern)_\(tile.tileType.rawValue)"] = SKTexture(image: tilemap.tileset.image(for: tile))
            }
            
            tileset = textures
        }
    }
    
    let tilemap = Tilemap()
    
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
}
