//
//  FoliageChunk2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class FoliageChunk2D: NonUniformChunk2D {
    
    private enum CodingKeys: CodingKey {
        
        case foliageType
        case foliageSize
    }
    
    var foliageType: FoliageType = .tree {
        
        didSet {
            
            if oldValue != foliageType {
                
                becomeDirty()
            }
        }
    }
    
    var foliageSize: FoliageSize = .small {
        
        didSet {
            
            if oldValue != foliageSize {
                
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
        foliageSize = try container.decode(FoliageSize.self, forKey: .foliageSize)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliageType, forKey: .foliageType)
        try container.encode(foliageSize, forKey: .foliageSize)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        switch foliageType {
        
        case .bush: color = .systemTeal
        case .flower: color = .systemOrange
        default: color = .systemGreen
        }
        
        return super.clean()
    }
}

extension FoliageChunk2D {
    
    public static func == (lhs: FoliageChunk2D, rhs: FoliageChunk2D) -> Bool {
        
        return lhs.footprint == rhs.footprint && lhs.foliageType == rhs.foliageType
    }
}
