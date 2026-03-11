//
//  ToolOptionsViewModel.swift
//  Core
//
//  Created by Zack Brown on 08/02/2026.
//

import Base
import Bivouac
import Deltille
import Harvest
import Newel

@MainActor
public class ToolOptionsViewModel {
    
    private(set) public var biome: Biome = .boreal
    private(set) public var footpathType: FootpathType = .dirt
    private(set) public var septomino: Triangle.Septomino = .antlia
    private(set) public var sculpt: Bool = true
    private(set) public var staircaseType: StaircaseType = .large
    private(set) public var waterType: WaterType = .ocean
    
    private(set) public var tool: Tool
    private(set) public var cursorStyle: CursorStyle = .vertex
    
    public init(tool: Tool) {
        
        self.tool = tool
    }
}

extension ToolOptionsViewModel {
    
    // MARK: Tool
    
    public func select(tool value: Tool) {
        
        self.tool = value
        
        guard !cursorStyles.contains(cursorStyle),
              let defaultCursorStyle = cursorStyles.first else { return }
        
        select(cursorStyle: defaultCursorStyle)
    }
    
    // MARK: Cursor
    
    public var cursorStyles: [CursorStyle] {
        
        switch tool {
            
        case .buildings: [.footprint(.init(.zero,
                                           septomino.coordinates))]
            
        case .foliage: [.triangle,
                        .hexagonal]
            
        case .footpaths: [.vertex]
            
        case .portals: [.triangle]
            
        case .staircases: [.footprint(.init(.zero,
                                            staircaseType.footprint.tiles))]
            
        case .terrain: [.vertex,
                        .triangle,
                        .hexagonal]
            
        case .water: [.triangle,
                      .hexagonal]
            
        default: []
        }
    }
    
    public func select(cursorStyle value: CursorStyle) {
        
        self.cursorStyle = value
    }
    
    // MARK: Buildings
    
    internal func select(septomino value: Triangle.Septomino) {
        
        self.septomino = value
    }
    
    // MARK: Footpaths
    
    internal func select(footpathType value: FootpathType) {
        
        self.footpathType = value
    }
    
    // MARK: Staircases
    
    internal func select(staircaseType value: StaircaseType) {
        
        self.staircaseType = value
    }
    
    // MARK: Terrain
    
    internal func select(biome value: Biome) {
        
        self.biome = value
    }
    
    internal func select(sculpt value: Bool) {
        
        self.sculpt = value
    }
    
    // MARK: Water
    
    internal func select(waterType value: WaterType) {
        
        self.waterType = value
    }
}
