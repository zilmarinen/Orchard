//
//  Tile2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow
import SpriteKit

class Tile2D: SKSpriteNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
                
                becomeDirty(recursive: true)
            }
        }
    }
    
    var neighbours: [Cardinal : Tile2D] = [:] {
        
        didSet {
            
            becomeDirty(recursive: true)
        }
    }
    
    required init(coordinate: Coordinate) {
            
        self.coordinate = coordinate
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult func becomeDirty(recursive: Bool) -> Bool {
        
        if recursive {
            
            for cardinal in Cardinal.allCases {
                
                guard let neighbour = find(neighbour: cardinal) else { continue }
                
                neighbour.becomeDirty()
            }
            
            for ordinal in Ordinal.allCases {
                
                guard let neighbour = find(neighbour: ordinal) else { continue }
                
                neighbour.becomeDirty()
            }
        }
        
        guard !isDirty else { return false }
        
        isDirty = true
        
        ancestor?.child(didBecomeDirty: self)
        
        return true
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty,
              let parent = parent as? Chunk2D<Self> else { return false }
        
        anchorPoint = .zero
        position = CGPoint(x: coordinate.x - parent.bounds.start.x, y: coordinate.z - parent.bounds.start.z)
        
        blendMode = .replace
        
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
            
            neighbour.becomeDirty(recursive: true)
        }
        
        becomeDirty(recursive: true)
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
        
        becomeDirty(recursive: true)
        
        neighbours.removeValue(forKey: cardinal)
        
        if neighbour.neighbours[cardinal.opposite] == self {
            
            neighbour.remove(neighbour: cardinal.opposite)
            
            neighbour.becomeDirty(recursive: true)
        }
    }
}
