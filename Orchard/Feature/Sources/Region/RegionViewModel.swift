//
//  RegionViewModel.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Cobble
import Deltille
import Euclid
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
    
    // MARK: Editor View
    
    internal let editorView = with(EditorView(frame: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    internal lazy var toolOptionsViewModel = ToolOptionsViewModel(tool: .terrain,
                                                                  delegate: self)
    
    private(set) var contents: [any TreeNode] = []
    
    private(set) var selection: Selection = .none
    
    internal let region: RegionSlice
    internal unowned(unsafe) var document: Document
    
    internal init(vertex: Triangle.Vertex,
                  document: Document) {
        
        do {
            
            self.region = try document.region(for: vertex) ?? document.create(region: vertex)
            self.document = document
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
    }
}

extension RegionViewModel {
    
    internal var identifier: String {
        
        document.region(intermediate: region.vertex)?.identifier ?? ""
    }
    
    internal var isEmpty: Bool {
        
        region.isEmpty
    }
}

extension RegionViewModel {
    
    internal func location(_ point: CGPoint) -> CGPoint {
     
        editorView.convert(point,
                           from: nil)
    }
    
    internal func hit(_ point: CGPoint) -> Triangle.HitTest? {
        
        guard let pointInWorld = editorView.hit(point) else { return nil }
        
        return .init(pointInWorld,
                     .tile)
    }
    
    internal func triangles(for hit: Triangle.HitTest) -> [Triangle] {
        
        switch toolOptionsViewModel.cursorStyle {
            
        case .footprint: [hit.triangle]
        case .hexagonal: hit.vertex.tiles
        case .triangle: [hit.triangle]
        case .vertex: []
        }
    }
    
    internal func vertices(for hit: Triangle.HitTest) -> [Triangle.Vertex] {
        
        switch toolOptionsViewModel.cursorStyle {
            
        case .footprint: hit.triangle.vertices
        case .hexagonal: hit.vertex.vertices + [hit.vertex]
        case .triangle: hit.triangle.vertices
        case .vertex: [hit.vertex]
        }
    }
    
    internal func canEdit(_ vertex: Triangle.Vertex) -> Bool {
        
        for tile in vertex.tiles {
            
            let triangle = tile.transpose(.tile,
                                          .region)
            
            if triangle.vertex == region.vertex {
                
                return true
            }
        }
        
        return false
    }
}

extension RegionViewModel {
    
    internal func template(_ scale: Triangle.Scale,
                           _ biome: Biome,
                           _ elevation: Int) {
        
        let triangle = Triangle(region.vertex)
        
        let template = triangle.transpose(.region,
                                          scale)
        
        let sieve = template.sieve(for: scale)
        
        for vertex in sieve.vertices {
            
            editorView.set(biome,
                           elevation,
                           for: vertex)
        }
    }
    
    internal func load() throws {
        
        let triangle = Triangle(region.vertex)
        
        let regions = try triangle.perimeter.compactMap {
            
            try document.region(for: $0.vertex)
        }
        
        editorView.load(regions: regions + [region])
        
        editorView.camera(focus: triangle.vertex.position(.region))
    }
    
    internal func save() throws {
        
        let triangle = Triangle(region.vertex)
        
        let regions = editorView.save(regions: [triangle] + triangle.perimeter)
        
        for region in regions {
            
            try document.save(region: region)
        }
    }
    
    internal func reload() {
        
        contents = [OutlineViewNode(displayName: identifier,
                                    children: [],
                                    isGroup: true)]
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
    
    // MARK: Camera
    
    internal func camera(focus value: Vector) {
        
        editorView.camera(focus: value)
    }
    
    internal func camera(rotate value: Hexagon.Rotation) {
        
        editorView.camera(rotate: value)
    }
    
    internal func camera(translate value: Vector) {
        
        editorView.camera(translate: value.normalized())
    }
    
    internal func camera(zoom value: Double) {
        
        editorView.camera(zoom: value)
    }
    
    // MARK: Cursor
    
    internal func cursor(focus value: Vector) {
        
        editorView.cursor(focus: value)
    }
    
    internal func cursor(rotate value: Triangle.Rotation) {
        
        editorView.cursor(rotate: value)
    }
    
    internal func cursor(toggle value: CursorStyle) {
        
        editorView.cursor(toggle: value)
    }
    
    // MARK: Buildings
    
    internal var septomino: Triangle.Septomino { toolOptionsViewModel.septomino }
    
    internal func update(buildings hit: Triangle.HitTest,
                         button: MouseButton) {
     
        guard button == .left else {
            
            return editorView.remove(building: hit.triangle)
        }
        
        editorView.set(septomino,
                       for: hit.triangle)
    }
    
    // MARK: Fences
    
    internal var rampart: Rampart { toolOptionsViewModel.rampart }
    internal var segment: FenceSegment { toolOptionsViewModel.segment }
    
    internal func update(fence hit: Triangle.HitTest,
                         button: MouseButton) {
        
        guard button == .left else {
            
            return editorView.remove(fence: hit.vertex)
        }
        
        editorView.set(rampart,
                       segment,
                       for: hit.vertex)
    }
    
    // MARK: Foliage
    
    internal func update(foliage hit: Triangle.HitTest,
                         button: MouseButton) {
     
        guard button == .left else {
            
            return editorView.remove(foliage: hit.vertex)
        }
        
        editorView.set(foliage: hit.vertex)
    }
    
    // MARK: Footpaths
    
    internal var design: Design { toolOptionsViewModel.design }
    
    internal func update(footpath hit: Triangle.HitTest,
                         button: MouseButton) {
        
        guard button == .left else {
            
            return editorView.remove(footpath: hit.vertex)
        }
        
        editorView.set(design,
                       for: hit.vertex)
    }
    
    // MARK: Portals
    
    internal func update(portal hit: Triangle.HitTest,
                         button: MouseButton) {
        
        guard button == .left else {
            
            return editorView.remove(portal: hit.triangle)
        }
        
        editorView.add(portal: hit.triangle)
    }
    
    // MARK: Slopes
    
    internal var slope: Slope { toolOptionsViewModel.slope }
    internal var rise: Rise { toolOptionsViewModel.rise }
    internal var cast: Cast { toolOptionsViewModel.cast }
    
    internal func update(slopes hit: Triangle.HitTest,
                         button: MouseButton) {
        
        guard button == .left else {
            
            return editorView.remove(slope: hit.triangle)
        }
        
        editorView.set(slope,
                       rise,
                       cast,
                       for: hit.triangle)
    }
    
    // MARK: Terrain
    
    internal var biome: Biome { toolOptionsViewModel.biome }
    internal var sculpt: Bool { toolOptionsViewModel.sculpt }
    
    internal func update(terrain hit: Triangle.HitTest,
                         button: MouseButton) {
        
        vertices(for: hit).forEach {
            
            let tile = editorView.get(biome: $0)
            
            let biome = sculpt ? (tile?.biome ?? biome) : biome
            
            let elevation = tile?.elevation ?? 0
            let adjustment = button == .left ? 1 : -1
            let adjusted = sculpt ? max(0, elevation + adjustment) : elevation
            
            editorView.set(adjusted > 0 ? biome : nil,
                           adjusted,
                           for: $0)
        }
    }
    
    // MARK: Water
    
    internal var waterType: WaterType { toolOptionsViewModel.waterType }
    
    internal func update(water hit: Triangle.HitTest,
                         button: MouseButton) {
        
        let biome = editorView.get(biome: hit.vertex)
        let tile = editorView.get(water: hit.triangle)
        let elevation = tile?.elevation ?? biome?.elevation ?? 0
        let adjusted = max(0, button == .left ? elevation + 1 : elevation - 1)
        
        triangles(for: hit).forEach {
            
            guard adjusted > 0 else {
                
                return editorView.remove(water: $0)
            }
            
            editorView.set(waterType,
                           adjusted,
                           for: $0)
        }
    }
}

extension RegionViewModel: @preconcurrency ToolOptionsDelegate {
    
    func toolOptionsViewModel(_ viewModel: ToolOptionsViewModel,
                              didSelect cursorStyle: CursorStyle) {
        
        editorView.cursor(toggle: cursorStyle)
    }
}
