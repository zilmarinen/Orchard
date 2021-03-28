//
//  Buildings2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Meadow
import SpriteKit

class Buildings2D: NonUniformGrid2D<BuildingChunk2D> {
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        
        return super.clean()
    }
    
    override func add(chunk footprint: Footprint, configure: ChunkConfiguration? = nil) -> BuildingChunk2D? {
        
        guard let editor = ancestor as? Editor else { return nil }
        
        for coordinate in footprint.nodes {
            
            let tile = editor.surface.find(tile: coordinate)
            
            if tile?.coordinate.y != footprint.coordinate.y {
                
                return nil
            }
        }
        
        return super.add(chunk: footprint, configure: configure)
    }
}
