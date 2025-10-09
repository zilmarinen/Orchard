//
//  TerrainInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import Harvest

@MainActor
public class TerrainInspectorViewModel {
    
    public private(set) var terrainType: TerrainType = .boreal
    
    public init(terrainType: TerrainType) {
        
        self.terrainType = terrainType
    }
}

extension TerrainInspectorViewModel {
    
    internal var terrainTypes: [TerrainType] {
        
        TerrainType.allCases
    }
}

extension TerrainInspectorViewModel {
    
    internal func select(terrainType value: TerrainType) {
        
        terrainType = value
    }
    
    internal func terrainType(at index: Int) -> TerrainType {
        
        terrainTypes[index]
    }
}
