//
//  RegionViewModel.swift
//  Feature
//
//  Created by Zack Brown on 30/07/2025.
//

import Base
import Deltille

@MainActor
internal class RegionViewModel {
    
    internal let coordinate: Coordinate
    internal unowned(unsafe) var document: Document
    
    internal init(coordinate: Coordinate,
                  document: Document) {
     
        self.coordinate = coordinate
        self.document = document
    }
}

extension RegionViewModel {
    
    internal var hasIntermediate: Bool { intermediate != nil }
    
    internal var intermediate: RegionIntermediate? { document.region(for: coordinate) }
    
    internal var identifier: String {
        
        intermediate?.displayName ?? ""
    }
}
