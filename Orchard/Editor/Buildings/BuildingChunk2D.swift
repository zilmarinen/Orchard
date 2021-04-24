//
//  BuildingChunk2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class BuildingChunk2D: NonUniformChunk2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case buildingType = "t"
    }
    
    var buildingType: BuildingType = .house {
        
        didSet {
            
            if oldValue != buildingType {
                
                becomeDirty()
            }
        }
    }
    
    required init(footprint: Footprint) {
            
        super.init(footprint: footprint)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        buildingType = try container.decode(BuildingType.self, forKey: .buildingType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(buildingType, forKey: .buildingType)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        let tilemap = map.meadow.foliage.tilemap
        
        blendMode = .alpha
        color = buildingType.color.color
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(buildingType.color.red),
                                      Float(buildingType.color.green),
                                      Float(buildingType.color.blue),
                                      Float(buildingType.color.alpha))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        return super.clean()
    }
}
