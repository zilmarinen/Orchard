//
//  Foliage2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Meadow
import SpriteKit

class Foliage2D: NonUniformGrid2D<FoliageChunk2D> {
    
    struct Tilemap {
        
        let shader = SKShader(shader: .foliage)
        
        init() {
            
            shader.attributes = [SKAttribute(name: SKAttribute.Attribute.color.rawValue, type: .vectorFloat4)]
        }
    }
    
    let tilemap = Tilemap()
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        
        return super.clean()
    }
    
    override func add(chunk footprint: Footprint, configure: ChunkConfiguration? = nil) -> FoliageChunk2D? {
        
        guard let editor = ancestor as? Editor else { return nil }
        
        for coordinate in footprint.nodes {
            
            if !editor.validate(coordinate: coordinate, grid: .foliage) {
                
                return nil
            }
        }
        
        return super.add(chunk: footprint, configure: configure)
    }
}
