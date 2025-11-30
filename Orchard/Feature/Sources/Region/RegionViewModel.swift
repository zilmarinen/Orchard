//
//  RegionViewModel.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import Base
import Deltille
import Foundation
import Harvest
import Inspector
import Newel

@MainActor
internal class RegionViewModel {
    
    internal let toolInspectorViewModel = ToolInspectorViewModel()
    internal let foliageInspectorViewModel = FoliageInspectorViewModel()
    internal let terrainInspectorViewModel = TerrainInspectorViewModel()
    
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
        
        editor.set(camera: region.triangle.vertex.position(.region))
    }
    
    internal func save(editor: RegionView) {
        
        let regions = editor.save(regions: region.triangle)
        
        for region in regions {
            
            document.save(region: region)
        }
    }
}

// MARK: Tool

extension RegionViewModel {
    
    internal var tool: Tool {
        
        toolInspectorViewModel.tool
    }
    
    internal var cursorStyle: CursorStyle {
        
        toolInspectorViewModel.cursorStyle
    }
    
    internal func tiles(for hit: HitTest) -> [Triangle] {
        
        switch cursorStyle {
            
        case .hexagonal: hit.vertex.tiles
        case .triangle: [hit.triangle]
        case .vertex: []
        }
    }
    
    internal func vertices(for hit: HitTest) -> [Triangle.Vertex] {
        
        switch cursorStyle {
            
        case .hexagonal: hit.vertex.vertices + [hit.vertex]
        case .triangle: hit.triangle.vertices
        case .vertex: [hit.vertex]
        }
    }
}

// MARK: Staircases

extension RegionViewModel {
    
    internal var stoop: Stoop {
        
        .small
    }
}

// MARK: Terrain

extension RegionViewModel {
    
    internal var biome: Biome {
        
        terrainInspectorViewModel.biome
    }
    
    public var sculpt: Bool {
        
        terrainInspectorViewModel.sculpt
    }
    
    public var paint: Bool {
        
        terrainInspectorViewModel.paint
    }
}
