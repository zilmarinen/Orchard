//
//  RegionInspectorViewModel.swift
//
//  Created by Zack Brown on 25/07/2025.
//

import Base
import Deltille
import Harvest

@MainActor
internal class RegionInspectorViewModel {
    
    internal let triangle: Triangle
    private unowned(unsafe) var document: Document
    
    internal init(triangle: Triangle,
                  document: Document) {
     
        self.triangle = triangle
        self.document = document
    }
}

extension RegionInspectorViewModel {
    
    internal func update(identifier value: String) {
        
        guard var intermediate else { return }
        
        intermediate.identifier = value
        
        document.save(region: intermediate)
    }
}

extension RegionInspectorViewModel {
    
    internal var hasIntermediate: Bool { intermediate != nil }
    
    internal var intermediate: Region? { document.region(for: triangle) }
    
    internal var identifier: String {
        
        intermediate?.displayName ?? ""
    }
}
