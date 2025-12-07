//
//  WaterInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 07/12/2025.
//

import Deltille
import Harvest

@MainActor
public class WaterInspectorViewModel {
    
    public private(set) var waterType: WaterType = .river
    
    public init() {}
}

extension WaterInspectorViewModel {
    
    internal var waterTypes: [WaterType] {
        
        WaterType.allCases
    }
}

extension WaterInspectorViewModel {
    
    internal func select(waterType value: WaterType) {
        
        waterType = value
    }
    
    internal func waterType(at index: Int) -> WaterType {
        
        waterTypes[index]
    }
}
