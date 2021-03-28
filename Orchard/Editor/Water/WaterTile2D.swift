//
//  WaterTile2D.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class WaterTile2D: Tile2D {
    
    private enum CodingKeys: CodingKey {
        
        case tileType
        case pattern
    }
    
    var tileType: WaterTileType = .water {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: Int = 1
    
    lazy var label: SKLabelNode = {
       
        let node = SKLabelNode()
        
        node.fontSize = 10
        node.fontColor = .black
        node.blendMode = .replace
        node.setScale(0.07)
        node.position = CGPoint(x: 0.5, y: 0.2)
        node.zPosition = 1
        node.isHidden = true
        
        return node
    }()
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(label)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
        try super.init(from: decoder)
        
        addChild(label)
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
        
        guard super.clean(),
              let map = map else { return false }
        
        let tilemap = map.meadow.water.tilemap
        
        color = tileType.color.color
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(tileType.color.red),
                                      Float(tileType.color.green),
                                      Float(tileType.color.blue),
                                      Float(tileType.color.alpha))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: "a_color")
        
        switch map.meadow.water.overlay {
        
        case .none:
            
            label.isHidden = true
            
        case .elevation:
            
            label.text = "\(coordinate.y)"
            label.isHidden = false
        }
        
        blendMode = .alpha
        
        return true
    }
    
    override func collapse() {
        
        super.collapse()
        
        var pattern = GridPattern(value: true)
        
        for ordinal in Ordinal.allCases {
            
            guard let neighbour = find(neighbour: ordinal),
                  neighbour.tileType.rawValue > tileType.rawValue else { continue }
            
            switch ordinal {
            
            case .northWest: pattern.northWest = false
            case .northEast: pattern.northEast = false
            case .southEast: pattern.southEast = false
            case .southWest: pattern.southWest = false
            }
        }
        
        for cardinal in Cardinal.allCases {
                    
            guard let neighbour = find(neighbour: cardinal),
                  neighbour.tileType.rawValue > tileType.rawValue else { continue }
            
            switch cardinal {
            
            case .north:
                
                pattern.north = false
                pattern.northWest = false
                pattern.northEast = false
                
            case .east:
                
                pattern.east = false
                pattern.northEast = false
                pattern.southEast = false
                
            case .south:
                
                pattern.south = false
                pattern.southEast = false
                pattern.southWest = false
                
            case .west:
                
                pattern.west = false
                pattern.northWest = false
                pattern.southWest = false
            }
        }
        
        self.pattern = GridPattern.index(of: pattern) + 1
    }
}

extension WaterTile2D {
    
    public static func == (lhs: WaterTile2D, rhs: WaterTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
