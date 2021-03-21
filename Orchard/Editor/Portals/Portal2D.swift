//
//  Portal2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class Portal2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case footprint
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
    
    required init(footprint: Footprint) {
            
        self.footprint = footprint
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        
        super.init()
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
    }
}

extension Portal2D {
    
    public static func == (lhs: Portal2D, rhs: Portal2D) -> Bool {
        
        return lhs.footprint == rhs.footprint
    }
}

extension Portal2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: footprint.coordinate.x, y: footprint.coordinate.z)
        
        path = CGPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1), transform: nil)
        
        fillColor = .systemYellow
        blendMode = .multiplyAlpha
        
        isDirty = false
        
        return true
    }
}

