//
//  TerrainInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import Harvest

@MainActor
public class TerrainInspectorViewModel {
    
    public private(set) var biome: Biome = .boreal
    public private(set) var sculpt: Bool = true
    public private(set) var paint: Bool = false
}

extension TerrainInspectorViewModel {
    
    // MARK: Biome
    
    internal var biomes: [Biome] {
        
        Biome.allCases
    }
    
    internal func biome(at index: Int) -> Biome {
        
        biomes[index]
    }
    
    internal func select(biome value: Biome) {
        
        biome = value
    }
    
    // MARK: Sculpt
    
    internal func toggle(sculpt value: Bool) {
        
        sculpt = value
    }
    
    // MARK: Paint
    
    internal func toggle(paint value: Bool) {
        
        paint = value
    }
}
