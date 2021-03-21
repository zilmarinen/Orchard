//
//  Water2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Meadow
import SpriteKit

class Water2D: Grid2D<WaterChunk2D, WaterTile2D> {
    
    var showElevation: Bool = false {
        
        didSet {
            
            tiles.forEach { tile in
                
                tile.label.isHidden = !showElevation
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
    
    override func add(tile coordinate: Coordinate, configure: Grid2D<WaterChunk2D, WaterTile2D>.TileConfiguration? = nil) -> WaterTile2D? {
        
        guard let editor = ancestor as? Editor,
              let tile = editor.surface.find(tile: coordinate),
              tile.coordinate.y < coordinate.y else { return nil }
        
        return super.add(tile: coordinate, configure: configure)
    }
}
