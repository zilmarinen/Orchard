//
//  SurfaceTile2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class SurfaceTile2D: Tile2D {
    
    private enum CodingKeys: CodingKey {
        
        case tileType
        case edgeType
    }
    
    var tileType: SurfaceTileType = .dirt {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    var edgeType: SurfaceEdgeType = .terraced {
        
        didSet {
            
            if oldValue != edgeType {
                
                becomeDirty()
            }
        }
    }
    
    var pattern: GridPattern = GridPattern(value: false) {
        
        didSet {
            
            if oldValue != pattern {
                
                becomeDirty()
            }
        }
    }
    
    lazy var label: SKLabelNode = {
       
        let node = SKLabelNode()
        
        node.fontSize = 10
        node.fontColor = .black
        node.blendMode = .multiplyAlpha
        node.setScale(0.07)
        node.position = CGPoint(x: 0.5, y: 0.2)
        node.isHidden = true
        
        return node
    }()
    
    required init(coordinate: Coordinate) {
            
        super.init(coordinate: coordinate)
        
        addChild(label)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        edgeType = try container.decode(SurfaceEdgeType.self, forKey: .edgeType)
        
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
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        fillColor = tileType.color.color
        label.zPosition = 1
        label.text = "\(coordinate.y)"
        for child in children {
            
            child.removeFromParent()
        }
        addChild(label)
        let size = CGSize(width: 0.33, height: 0.33)
        
        let nw = SKSpriteNode(color: pattern.northWest ? tileType.color.color : MDWColor.red, size: size)
        let n = SKSpriteNode(color: pattern.north ? tileType.color.color : MDWColor.red, size: size)
        let ne = SKSpriteNode(color: pattern.northEast ? tileType.color.color : MDWColor.red, size: size)
        let e = SKSpriteNode(color: pattern.east ? tileType.color.color : MDWColor.red, size: size)
        let se = SKSpriteNode(color: pattern.southEast ? tileType.color.color : MDWColor.red, size: size)
        let s = SKSpriteNode(color: pattern.south ? tileType.color.color : MDWColor.red, size: size)
        let sw = SKSpriteNode(color: pattern.southWest ? tileType.color.color : MDWColor.red, size: size)
        let w = SKSpriteNode(color: pattern.west ? tileType.color.color : MDWColor.red, size: size)
        let c = SKSpriteNode(color: tileType.color.color, size: size)
        
        nw.position = CGPoint(x: 0.5 + size.width, y: 0.5 + size.height)
        n.position = CGPoint(x: 0.5, y: 0.5 + size.height)
        ne.position = CGPoint(x: 0.5 - size.width, y: 0.5 + size.height)
        e.position = CGPoint(x: 0.5 - size.width, y: 0.5)
        se.position = CGPoint(x: 0.5 - size.width, y: 0.5 - size.height)
        s.position = CGPoint(x: 0.5, y: 0.5 - size.height)
        sw.position = CGPoint(x: 0.5 + size.width, y: 0.5 - size.height)
        w.position = CGPoint(x: 0.5 + size.width, y: 0.5)
        c.position = CGPoint(x: 0.5, y: 0.5)
        
        addChild(nw)
        addChild(n)
        addChild(ne)
        addChild(e)
        addChild(se)
        addChild(s)
        addChild(sw)
        addChild(w)
        addChild(c)
        
        return super.clean()
    }
    
    override func collapse() {
        
        super.collapse()
        
        pattern = GridPattern(value: true)
        
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
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
