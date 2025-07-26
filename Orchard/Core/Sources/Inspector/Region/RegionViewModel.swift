//
//  RegionViewModel.swift
//  Core
//
//  Created by Zack Brown on 25/07/2025.
//

import Base
import Deltille

@MainActor
internal class RegionViewModel {
    
    internal let coordinate: Coordinate
    private unowned(unsafe) var document: Document
    
    init(coordinate: Coordinate,
         document: Document) {
     
        self.coordinate = coordinate
        self.document = document
    }
}

extension RegionViewModel {
    
    internal func regionIntermediate(for coordinate: Coordinate) -> RegionIntermediate? {
        
        document.regionIntermediate(for: coordinate)
    }
    
    internal func update(identifier value: String) {
        
        guard let intermediate = regionIntermediate(for: coordinate) else { return }
        
        intermediate.identifier = value
    }
}

extension RegionViewModel {
    
    internal var hasIntermediate: Bool { regionIntermediate(for: coordinate) != nil }
    
    internal var identifier: String {
        
        guard let intermediate = regionIntermediate(for: coordinate) else { return "" }
        
        return intermediate.name
    }
}
