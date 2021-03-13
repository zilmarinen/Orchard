//
//  SurfaceTile2D.swift
//  Orchard
//
//  Created by Zack Brown on 10/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class SurfaceTile2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tileType
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty()
            }
        }
    }
    
    public var tileType: SurfaceTileType = .dirt {
        
        didSet {
            
            if oldValue != tileType {
                
                becomeDirty()
            }
        }
    }
    
    public var neighbours: [Cardinal : SurfaceTile2D] = [:] {
        
        didSet {
            
            becomeDirty()
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
            
        self.coordinate = coordinate
        
        super.init()
        
        blendMode = .multiplyAlpha
        
        addChild(label)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        
        super.init()
        
        blendMode = .multiplyAlpha
        
        addChild(label)
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tileType, forKey: .tileType)
    }
}

extension SurfaceTile2D {
    
    public static func == (lhs: SurfaceTile2D, rhs: SurfaceTile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}

extension SurfaceTile2D {
    
    func add(neighbour: SurfaceTile2D, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func find(neighbour cardinal: Cardinal) -> SurfaceTile2D? {
        
        return neighbours[cardinal]
    }
    
    func find(neighbour ordinal: Ordinal) -> SurfaceTile2D? {
        
        let (c0, c1) = ordinal.cardinals
        
        return find(neighbour: c0)?.find(neighbour: c1) ?? find(neighbour: c1)?.find(neighbour: c0)
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        guard let neighbour = neighbours[cardinal] else { return }
        
        neighbours.removeValue(forKey: cardinal)
        
        if neighbour.neighbours[cardinal.opposite] == self {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
    }
}

extension SurfaceTile2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty,
              let parent = parent as? SurfaceChunk2D else { return false }
        
        position = CGPoint(x: coordinate.x - parent.bounds.start.x, y: coordinate.z - parent.bounds.start.z)
        
        path = CGPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1), transform: nil)
        
        fillColor = tileType.color.color
        
        label.text = "\(coordinate.y)"
        
        isDirty = false
        
        return true
    }
}
