//
//  Building2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class Building2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
        case buildingType
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
    
    public var buildingType: Int = 1 {
        
        didSet {
            
            if oldValue != buildingType {
                
                becomeDirty()
            }
        }
    }
    
    required init(footprint: Footprint) {
            
        self.footprint = footprint
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        buildingType = try container.decode(Int.self, forKey: .buildingType)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
        try container.encode(buildingType, forKey: .buildingType)
    }
}

extension Building2D {
    
    public static func == (lhs: Building2D, rhs: Building2D) -> Bool {
        
        return lhs.footprint == rhs.footprint && lhs.buildingType == rhs.buildingType
    }
}

extension Building2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: footprint.coordinate.x, y: footprint.coordinate.z)
        
        fillColor = .systemBrown
        blendMode = .multiplyAlpha
        
        isDirty = false
        
        return true
    }
}
