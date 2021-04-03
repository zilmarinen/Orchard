//
//  Bridges2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Meadow
import SpriteKit

class Bridges2D: NonUniformGrid2D<BridgeChunk2D> {
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        
        return super.clean()
    }
    
    override func add(chunk footprint: Footprint, configure: ChunkConfiguration? = nil) -> BridgeChunk2D? {
        
        guard let editor = ancestor as? Editor else { return nil }
        
        for coordinate in footprint.nodes {
            
            if !editor.validate(coordinate: coordinate, grid: .bridges) {
                
                return nil
            }
        }
        
        return super.add(chunk: footprint, configure: configure)
    }
}
