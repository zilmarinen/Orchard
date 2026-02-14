//
//  RegionInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 13/02/2026.
//

import Base
import Deltille
import Harvest

@MainActor
internal class RegionInspectorViewModel {
    
    public let triangle: Triangle
    private(set) unowned(unsafe) var document: Document
    
    internal init(triangle: Triangle,
                  document: Document) {
     
        self.triangle = triangle
        self.document = document
    }
}

extension RegionInspectorViewModel {
    
    internal var hasIntermediate: Bool { intermediate != nil }
    
    internal var intermediate: Region? { document.region(for: triangle) }
}

extension RegionInspectorViewModel {
    
    internal func update(identifier value: String) {
            
        guard var intermediate else { return }
        
        intermediate.identifier = value
        
        document.save(region: intermediate)
    }
}
