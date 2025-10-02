//
//  TerrainInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import Harvest

internal class TerrainInspectorViewModel {
    
    private(set) var terrainType: TerrainType = .boreal
}

extension TerrainInspectorViewModel {
    
    internal var terrainTypes: [TerrainType] {
        
        TerrainType.allCases
    }
}

extension TerrainInspectorViewModel {
    
    internal func select(terrainType value: TerrainType) {
        
        self.terrainType = value
    }
}
