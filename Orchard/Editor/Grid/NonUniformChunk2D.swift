//
//  NonUniformChunk2D.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Meadow
import SpriteKit

class NonUniformChunk2D: SKSpriteNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case footprint = "f"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let footprint: Footprint
    
    required init(footprint: Footprint) {
        
        self.footprint = footprint
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footprint = try container.decode(Footprint.self, forKey: .footprint)
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(footprint, forKey: .footprint)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        size = footprint.bounds.size
        
        position = CGPoint(x: Double(footprint.coordinate.x) + (Double(size.width) / 2.0), y: Double(footprint.coordinate.z) + (Double(size.height) / 2.0))
        
        blendMode = .replace
        
        isDirty = false
        
        return true
    }
}
