//
//  Footpath2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

class Footpath2D: Grid2D<FootpathChunk2D, FootpathTile2D> {
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //TODO: collapse tiles
        
        return super.clean()
    }
}
