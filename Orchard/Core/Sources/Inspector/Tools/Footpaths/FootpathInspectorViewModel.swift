//
//  FootpathInspectorViewModel.swift
//
//  Created by Zack Brown on 07/12/2025.
//

import Deltille
import Harvest

@MainActor
public class FootpathInspectorViewModel {
    
    public private(set) var footpathType: FootpathType = .dirt
    
    public init() {}
}

extension FootpathInspectorViewModel {
    
    internal var footpathTypes: [FootpathType] {
        
        FootpathType.allCases
    }
}

extension FootpathInspectorViewModel {
    
    internal func select(footpathType value: FootpathType) {
        
        footpathType = value
    }
    
    internal func footpathType(at index: Int) -> FootpathType {
        
        footpathTypes[index]
    }
}
