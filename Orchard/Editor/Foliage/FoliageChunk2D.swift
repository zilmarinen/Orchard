//
//  FoliageChunk2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class FoliageChunk2D: NonUniformChunk2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case foliageType = "t"
    }
    
    var foliageType: FoliageType = .treeSmall {
        
        didSet {
            
            if oldValue != foliageType {
                
                becomeDirty()
            }
        }
    }
    
    required init(footprint: Footprint) {
        
        super.init(footprint: footprint)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliageType = try container.decode(FoliageType.self, forKey: .foliageType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliageType, forKey: .foliageType)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean(),
              let map = map else { return false }
        
        let tilemap = map.meadow.foliage.tilemap
        
        blendMode = .alpha
        color = foliageType.color.color
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(foliageType.color.red),
                                      Float(foliageType.color.green),
                                      Float(foliageType.color.blue),
                                      Float(foliageType.color.alpha))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        return super.clean()
    }
}

extension FoliageChunk2D {
    
    public static func == (lhs: FoliageChunk2D, rhs: FoliageChunk2D) -> Bool {
        
        return lhs.footprint == rhs.footprint && lhs.foliageType == rhs.foliageType
    }
}
