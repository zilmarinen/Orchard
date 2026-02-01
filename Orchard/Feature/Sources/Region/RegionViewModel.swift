//
//  RegionViewModel.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import Base
import Deltille
import Foundation
import Harvest
import Newel

@MainActor
internal class RegionViewModel {
    
    internal let region: Region
    internal unowned(unsafe) var document: Document
    
    internal init(triangle: Triangle,
                  document: Document) {
     
        self.region = document.region(for: triangle) ?? document.create(region: triangle)
        self.document = document
    }
}

extension RegionViewModel {
    
    internal var identifier: String {
        
        region.displayName
    }
}

extension RegionViewModel {
    
    internal func canEdit(vertex: Triangle.Vertex) -> Bool {
        
        for tile in vertex.tiles {
            
            let triangle = tile.transpose(.tile,
                                          .region)
            
            if triangle == region.triangle {
                
                return true
            }
        }
        
        return false
    }
}

extension RegionViewModel {
    
    internal func load(editor: RegionView) {
        
        let regions = region.triangle.perimeter.compactMap {
            
            document.region(for: $0)
        }
        
        editor.load(regions: regions + [region])
        
        editor.camera(focus: region.triangle.vertex.position(.region))
    }
    
    internal func save(editor: RegionView) {
        
        let regions = editor.save(regions: region.triangle)
        
        for region in regions {
            
            document.save(region: region)
        }
    }
}
