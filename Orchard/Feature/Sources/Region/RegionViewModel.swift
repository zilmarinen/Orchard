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
    
    internal let region: RegionIntermediate
    internal unowned(unsafe) var document: Document
    
    internal init(coordinate: Coordinate,
                  document: Document) {
     
        self.region = document.region(for: coordinate) ?? document.create(region: coordinate)
        self.document = document
    }
}

extension RegionViewModel {
    
    internal var identifier: String {
        
        region.displayName
    }
}
