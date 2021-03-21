//
//  Buildings2D.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Meadow
import SpriteKit

class Buildings2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case buildings
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var buildings: [Building2D] = []
    
    override init() {
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        buildings = try container.decode([Building2D].self, forKey: .buildings)
        
        super.init()
        
        for building in buildings {
            
            addChild(building)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(buildings, forKey: .buildings)
    }
}

extension Buildings2D {
    
    typealias BuildingConfiguration = ((Building2D) -> Void)
    
    func add(building footprint: Footprint, configure: BuildingConfiguration? = nil) -> Building2D? {
        
        guard find(building: footprint) == nil else { return nil }
        
        let node = Building2D(footprint: footprint)
        
        buildings.append(node)
        
        addChild(node)
        
        configure?(node)
        
        becomeDirty()
        
        return node
    }
    
    func find(building coordinate: Coordinate) -> Building2D? {
        
        return buildings.first { $0.footprint.intersects(coordinate: coordinate) }
    }
    
    func find(building footprint: Footprint) -> Building2D? {
        
        return buildings.first { $0.footprint.intersects(footprint: footprint) }
    }
    
    func remove(building coordinate: Coordinate) {
        
        guard let node = find(building: coordinate),
              let index = buildings.firstIndex(of: node) else { return }
        
        buildings.remove(at: index)
        
        node.removeFromParent()
        
        becomeDirty()
    }
}

extension Buildings2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

