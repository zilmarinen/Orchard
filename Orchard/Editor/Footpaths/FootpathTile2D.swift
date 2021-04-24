//
//  FootpathTile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class FootpathTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
    }
    
    public var tileType: FootpathTileType = .dirt {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: Int = 1
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(pattern, forKey: .pattern)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let map = map else { return false }
        
        let tilemap = map.meadow.footpath.tilemap
        
        color = tileType.color.color
        texture = tilemap.tileset["\(pattern)_\(tileType.rawValue)"]
        shader = tilemap.shader
        
        return super.clean()
    }
    
    override func collapse() {
        
        super.collapse()
        
        var pattern = GridPattern(value: false)
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            guard let n0 = find(neighbour: c0),
                  let n1 = find(neighbour: c1),
                  let n2 = find(neighbour: ordinal),
                  n0.tileType.rawValue == tileType.rawValue,
                  n1.tileType.rawValue == tileType.rawValue,
                  n2.tileType.rawValue == tileType.rawValue else { continue }
            
            switch ordinal {
            
            case .northWest: pattern.northWest = true
            case .northEast: pattern.northEast = true
            case .southEast: pattern.southEast = true
            case .southWest: pattern.southWest = true
            }
        }
        
        for cardinal in Cardinal.allCases {
                    
            guard let neighbour = find(neighbour: cardinal),
                  neighbour.tileType.rawValue == tileType.rawValue else { continue }
            
            switch cardinal {
            
            case .north: pattern.north = true
            case .east: pattern.east = true
            case .south: pattern.south = true
            case .west: pattern.west = true
            }
        }
        
        self.pattern = GridPattern.index(of: pattern) + 1
    }
}

extension FootpathTile2D {
    
    public static func == (lhs: FootpathTile2D, rhs: FootpathTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
