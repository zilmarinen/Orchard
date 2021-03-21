//
//  Foliage2D.swift
//
//  Created by Zack Brown on 14/03/2021.
//

import Meadow
import SpriteKit

class Foliage2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case vegetation
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var vegetation: [Vegetation2D] = []
    
    override init() {
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        vegetation = try container.decode([Vegetation2D].self, forKey: .vegetation)
        
        super.init()
        
        for foliage in vegetation {
            
            addChild(foliage)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(vegetation, forKey: .vegetation)
    }
}

extension Foliage2D {
    
    typealias FoliageConfiguration = ((Vegetation2D) -> Void)
    
    func add(vegetation footprint: Footprint, configure: FoliageConfiguration? = nil) -> Vegetation2D? {
        
        guard find(vegetation: footprint) == nil else { return nil }
        
        guard let editor = ancestor as? Editor else { return nil }
        
        for coordinate in footprint.nodes {
            
            let tile = editor.surface.find(tile: coordinate)
            
            if tile?.coordinate.y != footprint.coordinate.y {
                
                return nil
            }
        }
        
        let node = Vegetation2D(footprint: footprint)
        
        vegetation.append(node)
        
        addChild(node)
        
        configure?(node)
        
        becomeDirty()
        
        return node
    }
    
    func find(vegetation coordinate: Coordinate) -> Vegetation2D? {
        
        return vegetation.first { $0.footprint.intersects(coordinate: coordinate) }
    }
    
    func find(vegetation footprint: Footprint) -> Vegetation2D? {
        
        return vegetation.first { $0.footprint.intersects(footprint: footprint) }
    }
    
    func remove(vegetation coordinate: Coordinate) {
        
        guard let node = find(vegetation: coordinate),
              let index = vegetation.firstIndex(of: node) else { return }
        
        vegetation.remove(at: index)
        
        node.removeFromParent()
        
        becomeDirty()
    }
}

extension Foliage2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        
        for foliage in vegetation {
            
            foliage.clean()
        }
        
        isDirty = false
        
        return true
    }
}

