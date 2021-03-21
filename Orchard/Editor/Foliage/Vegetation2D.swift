//
//  Vegetation2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class Vegetation2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
        case foliageType
        case foliageSize
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var footprint: Footprint {
        
        didSet {
            
            if oldValue != footprint {
                
                becomeDirty()
            }
        }
    }
    
    public var foliageType: FoliageType = .tree {
        
        didSet {
            
            if oldValue != foliageType {
                
                becomeDirty()
            }
        }
    }
    
    public var foliageSize: FoliageSize = .small {
        
        didSet {
            
            if oldValue != foliageSize {
                
                becomeDirty()
            }
        }
    }
    
    required init(footprint: Footprint) {
            
        self.footprint = footprint
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        foliageType = try container.decode(FoliageType.self, forKey: .foliageType)
        foliageSize = try container.decode(FoliageSize.self, forKey: .foliageSize)
        
        super.init()
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
        try container.encode(foliageType, forKey: .foliageType)
        try container.encode(foliageSize, forKey: .foliageSize)
    }
}

extension Vegetation2D {
    
    public static func == (lhs: Vegetation2D, rhs: Vegetation2D) -> Bool {
        
        return lhs.footprint == rhs.footprint && lhs.foliageType == rhs.foliageType
    }
}

extension Vegetation2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: footprint.coordinate.x, y: footprint.coordinate.z)
        
        path = CGPath(rect: CGRect(x: 0, y: 0, width: (foliageSize.rawValue + 1), height: (foliageSize.rawValue + 1)), transform: nil)
        
        switch foliageType {
        
        case .bush: fillColor = .systemTeal
        case .flower: fillColor = .systemOrange
        default: fillColor = .systemGreen
        }
        
        blendMode = .multiplyAlpha
        
        isDirty = false
        
        return true
    }
}
