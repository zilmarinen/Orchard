//
//  ZoneInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 28/07/2025.
//

import Base
import Deltille

@MainActor
internal class ZoneInspectorViewModel {
    
    internal let coordinate: Grid.Coordinate
    private unowned(unsafe) var document: Document
    
    init(coordinate: Grid.Coordinate,
         document: Document) {
     
        self.coordinate = coordinate
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
    
    internal var intermediate: ZoneIntermediate? { document.zone(for: coordinate) }
    
    internal var identifier: String {
        
        intermediate?.displayName ?? ""
    }
}
