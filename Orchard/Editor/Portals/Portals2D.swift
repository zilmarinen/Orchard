//
//  Portals2D.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Meadow
import SpriteKit

class Portals2D: SKShapeNode, Codable, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case portals
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var portals: [Portal2D] = []
    
    override init() {
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        portals = try container.decode([Portal2D].self, forKey: .portals)
        
        super.init()
        
        for portal in portals {
            
            addChild(portal)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(portals, forKey: .portals)
    }
}

extension Portals2D {
    
    typealias FoliageConfiguration = ((Portal2D) -> Void)
    
    func add(portal footprint: Footprint, configure: FoliageConfiguration? = nil) -> Portal2D? {
        
        guard find(portal: footprint) == nil else { return nil }
        
        let node = Portal2D(footprint: footprint)
        
        portals.append(node)
        
        addChild(node)
        
        configure?(node)
        
        becomeDirty()
        
        return node
    }
    
    func find(portal coordinate: Coordinate) -> Portal2D? {
        
        return portals.first { $0.footprint.intersects(coordinate: coordinate) }
    }
    
    func find(portal footprint: Footprint) -> Portal2D? {
        
        return portals.first { $0.footprint.intersects(footprint: footprint) }
    }
    
    func remove(portal coordinate: Coordinate) {
        
        guard let node = find(portal: coordinate),
              let index = portals.firstIndex(of: node) else { return }
        
        portals.remove(at: index)
        
        node.removeFromParent()
        
        becomeDirty()
    }
}

extension Portals2D {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        zPosition = 1
        
        for portal in portals {
            
            portal.clean()
        }
        
        isDirty = false
        
        return true
    }
}


