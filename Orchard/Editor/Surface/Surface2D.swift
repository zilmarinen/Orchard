//
//  Surface2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Meadow
import SpriteKit

class Surface2D: Grid2D<SurfaceChunk2D, SurfaceTile2D> {
    
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
}
