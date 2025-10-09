//
//  RegionViewModel.swift
//  Feature
//
//  Created by Zack Brown on 30/07/2025.
//

import Base
import Deltille
import Foundation
import Harvest
import Inspector

@MainActor
internal class RegionViewModel {
    
    internal let toolSelectionViewModel = ToolSelectionViewModel(selectedTool: .terrain)
    
    internal let region: Region
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

extension RegionViewModel {
    
    internal func canEdit(vertex: Triangle.Vertex) -> Bool {
        
        for tile in vertex.tiles {
            
            let triangle = tile.transpose(.tile,
                                          .region)
            
            if triangle.vertex.position == region.coordinate {
                
                return true
            }
        }
        
        return false
    }
}

extension RegionViewModel {
    
    internal func load(editor: RegionView) {
        
        let triangle = Triangle(region.coordinate)
        
        let regions = triangle.perimeter.compactMap {
            
            document.region(for: $0.vertex.position)
        }
        
        editor.load(regions: regions + [region])
        
        editor.camera.focus(on: triangle.vertex.position(.region))
    }
    
    internal func save(editor: RegionView) {
        
        let regions = editor.save()
        
        for region in regions {
            
            document.save(region: region)
        }
    }
}

// MARK: Tool

extension RegionViewModel {
    
    internal var selectedTool: Tool {
        
        toolSelectionViewModel.selectedTool
    }
}

// MARK: Terrain

extension RegionViewModel {
    
    internal var terrainType: TerrainType {
        
        toolSelectionViewModel.terrainType
    }
}
