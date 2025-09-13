//
//  RegionInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 25/07/2025.
//

import Base
import Deltille
import Harvest

@MainActor
internal class RegionInspectorViewModel {
    
    internal let coordinate: Coordinate
    private unowned(unsafe) var document: Document
    
    init(coordinate: Coordinate,
         document: Document) {
     
        self.coordinate = coordinate
        self.document = document
    }
}

extension RegionInspectorViewModel {
    
    internal func update(identifier value: String) {
        
        guard let intermediate else { return }
        
        intermediate.identifier = value
    }
}

extension RegionInspectorViewModel {
    
    internal var hasIntermediate: Bool { intermediate != nil }
    
    internal var intermediate: Region? { document.region(for: coordinate) }
    
    internal var identifier: String {
        
        intermediate?.displayName ?? ""
    }
}
