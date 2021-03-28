//
//  Editor.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class Editor: SKNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case actors
        case buildings
        case foliage
        case footpath
        case portals
        case surface
        case water
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let actors: Actors2D
    let buildings: Buildings2D
    let foliage: Foliage2D
    let footpath: Footpath2D
    let portals: Portals2D
    let surface: Surface2D
    let water: Water2D
    
    override init() {
        
        actors = Actors2D()
        buildings = Buildings2D()
        foliage = Foliage2D()
        footpath = Footpath2D()
        portals = Portals2D()
        surface = Surface2D()
        water = Water2D()
        
        super.init()
        
        addChild(actors)
        addChild(buildings)
        addChild(foliage)
        addChild(footpath)
        addChild(portals)
        addChild(surface)
        addChild(water)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode(Actors2D.self, forKey: .actors)
        buildings = try container.decode(Buildings2D.self, forKey: .buildings)
        foliage = try container.decode(Foliage2D.self, forKey: .foliage)
        footpath = try container.decode(Footpath2D.self, forKey: .footpath)
        portals = try container.decode(Portals2D.self, forKey: .portals)
        surface = try container.decode(Surface2D.self, forKey: .surface)
        water = try container.decode(Water2D.self, forKey: .water)
        
        super.init()
        
        addChild(actors)
        addChild(buildings)
        addChild(foliage)
        addChild(footpath)
        addChild(portals)
        addChild(surface)
        addChild(water)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(actors, forKey: .actors)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(portals, forKey: .portals)
        try container.encode(surface, forKey: .surface)
        try container.encode(water, forKey: .water)
    }
}

extension Editor {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        actors.clean()
        buildings.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        surface.clean()
        water.clean()
        
        isDirty = false
        
        return true
    }
}
