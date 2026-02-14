//
//  RegionViewModel.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import Base
import Deltille
import Foundation
import Harvest
import Lattice
import Newel
import Toolbox

@MainActor
internal class RegionViewModel {
    
    internal enum Selection {
        
        case none
        case portal(triangle: Triangle)
    }
    
    public let toolOptionsViewModel = ToolOptionsViewModel(tool: .terrain)
    
    private(set) var selection: Selection = .none
    
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

extension RegionViewModel {
    
    // MARK: Selection
    
    internal func update(selection value: Selection) { selection = value }
    
    // MARK: Tool
    
    internal var tool: Tool { toolOptionsViewModel.tool }
 
    internal func select(tool value: Tool) {
        
        toolOptionsViewModel.select(tool: value)
    }
    
    // MARK: Cursor
    
    internal func tiles(for hit: HitTest) -> [Triangle] {
            
        switch toolOptionsViewModel.cursorStyle {
            
        case .footprint: [hit.triangle]
        case .hexagonal: hit.vertex.tiles
        case .triangle: [hit.triangle]
        case .vertex: []
        }
    }
    
    internal func vertices(for hit: HitTest) -> [Triangle.Vertex] {
        
        switch toolOptionsViewModel.cursorStyle {
            
        case .footprint: hit.triangle.vertices
        case .hexagonal: hit.vertex.vertices + [hit.vertex]
        case .triangle: hit.triangle.vertices
        case .vertex: [hit.vertex]
        }
    }
    
    // MARK: Buildings
    
    internal var septomino: Triangle.Septomino { toolOptionsViewModel.septomino }
    
    // MARK: Footpaths
    
    internal var footpathType: FootpathType { toolOptionsViewModel.footpathType }
    
    // MARK: Staircases
    
    internal var staircaseType: StaircaseType { toolOptionsViewModel.staircaseType }
    
    // MARK: Terrain
    
    internal var biome: Biome { toolOptionsViewModel.biome }
    
    // MARK: Water
    
    internal var waterType: WaterType { toolOptionsViewModel.waterType }
}
