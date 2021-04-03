//
//  BridgeChunk2D.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class BridgeChunk2D: NonUniformChunk2D {
    
    private enum CodingKeys: CodingKey {
        
    }
    
    required init(footprint: Footprint) {
            
        super.init(footprint: footprint)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        //
    }
    
    @discardableResult public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: footprint.coordinate.x, y: footprint.coordinate.z)
        
        color = .systemTeal
        blendMode = .multiplyAlpha
        
        return super.clean()
    }
}

