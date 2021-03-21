//
//  FootpathTile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class FootpathTile2D: Tile2D {
    
    private enum CodingKeys: CodingKey {
        
        case tileType
    }
    
    public var tileType: FootpathTileType = .dirt {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        fillColor = tileType.color.color
        
        //
        
        return super.clean()
    }
}

extension FootpathTile2D {
    
    public static func == (lhs: FootpathTile2D, rhs: FootpathTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}

