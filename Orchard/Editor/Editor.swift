//
//  Editor.swift
//  Orchard
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class Editor: SKNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case surface
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public let surface: Surface2D
    
    override init() {
        
        surface = Surface2D()
        
        super.init()
        
        addChild(surface)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        surface = try container.decode(Surface2D.self, forKey: .surface)
        
        super.init()
        
        addChild(surface)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(surface, forKey: .surface)
    }
}

extension Editor {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        surface.clean()
        
        isDirty = false
        
        return true
    }
}
