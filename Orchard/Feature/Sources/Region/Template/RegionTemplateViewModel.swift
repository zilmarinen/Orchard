//
//  RegionTemplateViewModel.swift
//  Feature
//
//  Created by Zack Brown on 31/05/2026.
//

import Deltille
import Harvest

@MainActor
internal class RegionTemplateViewModel {
    
    private(set) var scale: Triangle.Scale = .chunk
    private(set) var biome: Biome = .boreal
    private(set) var elevation: Int = 3
}

extension RegionTemplateViewModel {
    
    // MARK: Scale
    
    internal var scales: [Triangle.Scale] {
        
        [.region,
         .chunk]
    }
    
    internal func select(scale value: Triangle.Scale) {
        
        scale = value
    }
    
    // MARK: Biome
    
    internal var biomes: [Biome] {
        
        Biome.allCases
    }
    
    internal func select(biome value: Biome) {
        
        biome = value
    }
    
    // MARK: Elevation
    
    internal var maximumElevation: Int {
        
        10
    }
    
    internal var minimumElevation: Int {
        
        1
    }
    
    internal func select(elevation value: Int) {
        
        elevation = value
    }
}
