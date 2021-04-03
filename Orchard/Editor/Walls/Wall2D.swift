//
//  Wall2D.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Meadow
import SpriteKit

class Wall2D: Grid2D<WallChunk2D, WallTile2D> {
    
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
