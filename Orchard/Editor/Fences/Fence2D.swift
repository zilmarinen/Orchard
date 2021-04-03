//
//  Fence2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

class Fence2D: Grid2D<FenceChunk2D, FenceTile2D> {
    
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
