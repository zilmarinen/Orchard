//
//  Editor.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class Editor: SKNode, Codable, Responder2D, Soilable {
    
    enum CodingKeys: CodingKey {
        
        case actors
        case bridges
        case buildings
        case fences
        case foliage
        case footpath
        case portals
        case surface
        case walls
        case water
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let actors: Actors2D
    let bridges: Bridges2D
    let buildings: Buildings2D
    let fences: Fence2D
    let foliage: Foliage2D
    let footpath: Footpath2D
    let portals: Portals2D
    let surface: Surface2D
    let walls: Wall2D
    let water: Water2D
    
    override init() {
        
        actors = Actors2D()
        bridges = Bridges2D()
        buildings = Buildings2D()
        fences = Fence2D()
        foliage = Foliage2D()
        footpath = Footpath2D()
        portals = Portals2D()
        surface = Surface2D()
        walls = Wall2D()
        water = Water2D()
        
        super.init()
        
        addChild(actors)
        addChild(bridges)
        addChild(buildings)
        addChild(fences)
        addChild(foliage)
        addChild(footpath)
        addChild(portals)
        addChild(surface)
        addChild(walls)
        addChild(water)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        actors = try container.decode(Actors2D.self, forKey: .actors)
        bridges = try container.decode(Bridges2D.self, forKey: .bridges)
        buildings = try container.decode(Buildings2D.self, forKey: .buildings)
        fences = try container.decode(Fence2D.self, forKey: .fences)
        foliage = try container.decode(Foliage2D.self, forKey: .foliage)
        footpath = try container.decode(Footpath2D.self, forKey: .footpath)
        portals = try container.decode(Portals2D.self, forKey: .portals)
        surface = try container.decode(Surface2D.self, forKey: .surface)
        walls = try container.decode(Wall2D.self, forKey: .walls)
        water = try container.decode(Water2D.self, forKey: .water)
        
        super.init()
        
        addChild(actors)
        addChild(bridges)
        addChild(buildings)
        addChild(fences)
        addChild(foliage)
        addChild(footpath)
        addChild(portals)
        addChild(surface)
        addChild(walls)
        addChild(water)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(actors, forKey: .actors)
        try container.encode(bridges, forKey: .bridges)
        try container.encode(buildings, forKey: .buildings)
        try container.encode(fences, forKey: .fences)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(portals, forKey: .portals)
        try container.encode(surface, forKey: .surface)
        try container.encode(walls, forKey: .walls)
        try container.encode(water, forKey: .water)
    }
}

extension Editor {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        actors.clean()
        bridges.clean()
        buildings.clean()
        fences.clean()
        foliage.clean()
        footpath.clean()
        portals.clean()
        surface.clean()
        walls.clean()
        water.clean()
        
        isDirty = false
        
        return true
    }
}

extension Editor {
    
    func validate(coordinate: Coordinate, grid: CodingKeys) -> Bool {
        
        switch grid {
        
        case .actors:
            
            guard buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  water.find(tile: coordinate) == nil else { return false }
            
        case .bridges:
            
            guard bridges.find(chunk: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  footpath.find(tile: coordinate) == nil else { return false }
            
        case .buildings:
            
            guard actors.find(actor: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  footpath.find(tile: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  water.find(tile: coordinate) == nil else { return false }
            
        case .fences:
            
            guard actors.find(actor: coordinate) == nil,
                  bridges.find(chunk: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  footpath.find(tile: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  water.find(tile: coordinate) == nil else { return false }
            
        case .foliage:
            
            guard actors.find(actor: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  water.find(tile: coordinate) == nil else { return false }
            
        case .footpath:
            
            guard bridges.find(chunk: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  water.find(chunk: coordinate) == nil else { return false }
            
        case .portals:
            
            guard actors.find(actor: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  water.find(chunk: coordinate) == nil else { return false }
            
        case .walls:
            
            guard actors.find(actor: coordinate) == nil,
                  bridges.find(chunk: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  footpath.find(tile: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil,
                  water.find(tile: coordinate) == nil else { return false }
            
        case .water:
            
            guard actors.find(actor: coordinate) == nil,
                  buildings.find(chunk: coordinate) == nil,
                  fences.find(tile: coordinate) == nil,
                  foliage.find(chunk: coordinate) == nil,
                  footpath.find(tile: coordinate) == nil,
                  portals.find(chunk: coordinate) == nil,
                  walls.find(tile: coordinate) == nil else { return false }
            
        default: break
        }
        
        return true
    }
}
