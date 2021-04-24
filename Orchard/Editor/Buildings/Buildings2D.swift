//
//  Buildings2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Meadow
import SpriteKit

class Buildings2D: NonUniformGrid2D<BuildingChunk2D> {
    
    struct Tilemap {
        
        let shader = SKShader(shader: .building)
        
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
    
    func add(building coordinate: Coordinate, rotation: Cardinal, buildingType: BuildingType, configure: ChunkConfiguration? = nil) -> BuildingChunk2D? {
        
        guard let model = buildingType.model,
              let editor = ancestor as? Editor else { return nil }
        
        let footprint = Footprint(coordinate: coordinate, rotation: rotation, nodes: model.footprint.nodes)
        
        for coordinate in footprint.nodes {
            
            if !editor.validate(coordinate: coordinate, grid: .buildings) {
                
                return nil
            }
        }
        
        guard let building = super.add(chunk: footprint) else { return nil }
        
        building.buildingType = buildingType
        
        return building
    }
}
