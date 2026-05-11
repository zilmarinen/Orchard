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
    
    private let intermediate: RegionIntermediate?
    
    public let vertex: Triangle.Vertex
    private(set) unowned(unsafe) var document: Document
    
    internal init(vertex: Triangle.Vertex,
                  document: Document) {
     
        self.vertex = vertex
        self.document = document
        self.intermediate = document.region(intermediate: vertex)
    }
}

extension RegionInspectorViewModel {
    
    internal var hasIntermediate: Bool {
        
        intermediate != nil
    }
    
    internal var identifier: String {
        
        intermediate?.identifier ?? vertex.id
    }
}

extension RegionInspectorViewModel {
    
    internal func update(identifier value: String) {
            
        document.update(region: vertex,
                        identifier: value)
    }
}
