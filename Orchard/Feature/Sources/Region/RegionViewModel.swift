//
//  RegionViewModel.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Cobble
import Deltille
import Foundation
import Harvest
import Lattice
import Newel
import Palisade
import Silhouette
import Toolbox

@MainActor
internal class RegionViewModel {
    
    internal enum Selection: Hashable {
        
        case none
        case portal(vertex: Triangle.Vertex)
    }
    
    public let toolOptionsViewModel = ToolOptionsViewModel(tool: .terrain)
    
    private(set) var contents: [any TreeNode] = []
    
    private(set) var selection: Selection = .none
    
    internal let region: Region
    internal unowned(unsafe) var document: Document
    
    internal init(vertex: Triangle.Vertex,
                  document: Document) {
     
        self.region = document.region(for: vertex) ?? document.create(region: vertex)
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
            
            if triangle.vertex == region.origin {
                
                return true
            }
        }
        
        return false
    }
    
    internal func reload() {
        
        let children = Tool.allCases.map {
            
            OutlineViewNode(displayName: $0.id,
                            image: $0.image,
                            children: self.children(for: $0))
        }
        
        contents = [OutlineViewNode(displayName: region.displayName,
                                    children: children,
                                    isGroup: true)]
    }
    
    internal func children(for tool: Tool) -> [OutlineViewNode] {
        
        switch tool {
            
        case .buildings:
            
            guard let grid = region.buildings?.region else { return [] }
            
            return grid.chunks.map { OutlineViewNode(displayName: $0.triangle.id,
                                                     image: NSImage(icon: .triangle),
                                                     children: []) }
            
        case .terrain:
            
            guard let grid = region.terrain?.region else { return [] }
            
            return grid.chunks.map { OutlineViewNode(displayName: $0.triangle.id,
                                                     image: NSImage(icon: .triangle),
                                                     children: []) }
            
        case .water:
            
            guard let grid = region.water?.region else { return [] }
            
            return grid.chunks.map { OutlineViewNode(displayName: $0.triangle.id,
                                                     image: NSImage(icon: .triangle),
                                                     children: []) }
            
        default: return []
        }
    }
}

extension RegionViewModel {
    
    internal func load(editor: EditorView) {
        
        let triangle = Triangle(region.origin)
        
        let regions = triangle.perimeter.compactMap {
            
            document.region(for: $0.vertex)
        }
        
        editor.load(regions: regions + [region])
        
        editor.camera(focus: triangle.vertex.position(.region))
    }
    
    internal func save(editor: EditorView) {
        
        let triangle = Triangle(region.origin)
        
        let regions = editor.save(regions: [triangle] + triangle.perimeter)
        
        for region in regions {
            
            document.save(region: region)
        }
    }
}

extension RegionViewModel {
    
    // MARK: Selection
    
    internal func update(selection value: Selection) { selection = value }
    
    // MARK: Tool
    
    internal var tools: [Tool] { Tool.allCases }
    
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
    
    // MARK: Fences
    
    internal var rampart: Rampart { toolOptionsViewModel.rampart }
    internal var segment: FenceSegment { toolOptionsViewModel.segment }
    
    // MARK: Footpaths
    
    internal var design: Design { toolOptionsViewModel.design }
    
    // MARK: Slopes
    
    internal var slope: Slope { toolOptionsViewModel.slope }
    internal var rise: Rise { toolOptionsViewModel.rise }
    internal var cast: Cast { toolOptionsViewModel.cast }
    
    // MARK: Terrain
    
    internal var biome: Biome { toolOptionsViewModel.biome }
    internal var sculpt: Bool { toolOptionsViewModel.sculpt }
    
    // MARK: Water
    
    internal var waterType: WaterType { toolOptionsViewModel.waterType }
}
