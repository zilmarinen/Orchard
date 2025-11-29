//
//  ZoneInspectorViewModel.swift
//
//  Created by Zack Brown on 28/07/2025.
//

import Base
import Deltille

@MainActor
internal class ZoneInspectorViewModel {
    
    internal let triangle: Triangle
    private unowned(unsafe) var document: Document
    
    init(triangle: Triangle,
         document: Document) {
     
        self.triangle = triangle
        self.document = document
    }
}

extension ZoneInspectorViewModel {
    
    internal func update(identifier value: String) {
        
        guard let intermediate else { return }
        
        intermediate.identifier = value
    }
}

extension ZoneInspectorViewModel {
    
    internal var hasIntermediate: Bool { intermediate != nil }
    
    internal var intermediate: ZoneIntermediate? { document.zone(for: triangle) }
    
    internal var identifier: String {
        
        intermediate?.displayName ?? ""
    }
}
