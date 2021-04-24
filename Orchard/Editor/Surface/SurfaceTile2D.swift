//
//  SurfaceTile2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class SurfaceTile2D: Tile2D {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
        case edgeType = "et"
        case pattern = "p"
        case edgePatterns = "ep"
        case corners = "co"
    }
    
    var tileType: SurfaceTile.TileType = SurfaceTile.TileType() {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    var edgeType: SurfaceEdgeType = .terraced {
        
        didSet {
            
            if oldValue != edgeType {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    var neighbourTileType: SurfaceTileType = .dirt
    var pattern: Int = 1
    var edgePatterns: [Cardinal : Int] = [:]
    var corners: [Ordinal : Int] = [:]
    
    lazy var label: SKLabelNode = {
       
        let node = SKLabelNode()
        
        node.fontSize = 10
        node.fontColor = .black
        node.blendMode = .replace
        node.setScale(0.07)
        node.position = CGPoint(x: 0.5, y: 0.2)
        node.zPosition = 1
        
        return node
    }()
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(label)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTile.TileType.self, forKey: .tileType)
        edgeType = try container.decode(SurfaceEdgeType.self, forKey: .edgeType)
        pattern = try container.decode(Int.self, forKey: .pattern)
        edgePatterns = try container.decode([Cardinal : Int].self, forKey: .edgePatterns)
        corners = try container.decode([Ordinal : Int].self, forKey: .corners)
        
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
        try container.encode(edgeType, forKey: .edgeType)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(edgePatterns, forKey: .edgePatterns)
        try container.encode(corners, forKey: .corners)
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty,
              let map = map else { return false }
        
        let tilemap = map.meadow.surface.tilemap
        
        let spriteColor = Color(red: Double(tileType.primary.rawValue), green: Double(tileType.secondary.rawValue), blue: 0, alpha: 1)
        
        color = spriteColor.color
        texture = tilemap.tileset["\(pattern)"]
        shader = tilemap.shader
        
        let attribute = vector_float4(Float(spriteColor.red),
                                      Float(spriteColor.green),
                                      Float(spriteColor.blue),
                                      Float(spriteColor.alpha))
        
        setValue(SKAttributeValue(vectorFloat4: attribute), forAttribute: SKAttribute.Attribute.color.rawValue)
        
        switch map.meadow.surface.overlay {
            
        case .edge:
            
            label.text = edgeType.abbreviation
            
        case .elevation,
             .material:
            
            label.text = "\(coordinate.y)"
        }
        
        return super.clean()
    }
    
    override func collapse() {
        
        super.collapse()
        
        tileType.secondary = tileType.primary
        
        var pattern = GridPattern(value: true)
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let h0 = find(neighbour: c0)?.coordinate.y ?? coordinate.y
            let h1 = find(neighbour: c1)?.coordinate.y ?? coordinate.y
            let neighbour = find(neighbour: ordinal)
            
            corners[ordinal] = min(h0, h1, neighbour?.coordinate.y ?? coordinate.y, coordinate.y)
            
            guard let neighbourTileType = neighbour?.tileType else { continue }
            
            guard neighbourTileType.primary.rawValue > tileType.primary.rawValue else { continue }
            
            tileType.secondary = (neighbourTileType.primary.rawValue > tileType.secondary.rawValue ? neighbourTileType.primary : tileType.secondary)
            
            switch ordinal {
            
            case .northWest: pattern.northWest = false
            case .northEast: pattern.northEast = false
            case .southEast: pattern.southEast = false
            case .southWest: pattern.southWest = false
            }
        }
        
        for cardinal in Cardinal.allCases {
            
            let (c0, c1) = cardinal.cardinals
            let (n0, n1) = (find(neighbour: c0), find(neighbour: c1))
            
            var edgePattern = GridPattern(value: true)
            
            if let n0 = n0,
               n0.tileType.primary.rawValue > tileType.primary.rawValue {
                
                edgePattern.northWest = false
                edgePattern.west = false
                edgePattern.southWest = false
            }
            
            if let n1 = n1,
               n1.tileType.primary.rawValue > tileType.primary.rawValue {
                
                edgePattern.northEast = false
                edgePattern.east = false
                edgePattern.southEast = false
            }
            
            edgePatterns[cardinal] = GridPattern.index(of: edgePattern) + 1
            
            guard let neighbour = find(neighbour: cardinal),
                  neighbour.tileType.primary.rawValue > tileType.primary.rawValue else { continue }
            
            tileType.secondary = (neighbour.tileType.primary.rawValue > tileType.secondary.rawValue ? neighbour.tileType.primary : tileType.secondary)
            
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

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
