//
//  Tile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class Tile2D: SKShapeNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty()
            }
        }
    }
    
    var neighbours: [Cardinal : Tile2D] = [:] {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    required init(coordinate: Coordinate) {
            
        self.coordinate = coordinate
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init()
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty,
              let parent = parent as? Chunk2D<Self> else { return false }
        
        position = CGPoint(x: coordinate.x - parent.bounds.start.x, y: coordinate.z - parent.bounds.start.z)
        
        path = CGPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1), transform: nil)
        
        blendMode = .multiplyAlpha
        
        isDirty = false
        
        return true
    }
    
    func collapse() {}
}

extension Tile2D {
    
    public static func == (lhs: Tile2D, rhs: Tile2D) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension Tile2D {
    
    func add(neighbour: Tile2D, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func find(neighbour cardinal: Cardinal) -> Self? {
        
        return neighbours[cardinal] as? Self
    }
    
    func find(neighbour ordinal: Ordinal) -> Self? {
        
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
