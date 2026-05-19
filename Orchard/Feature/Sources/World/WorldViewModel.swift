//
//  WorldViewModel.swift
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit
import Atlas
import Base
import Deltille
import Harvest
import SpriteKit
import Silhouette

@MainActor
internal class WorldViewModel {
    
    // MARK: Editor View
    
    internal let editorView = with(AtlasView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private(set) var contents: [any TreeNode] = []
    
    private(set) var selection: Document.Selection = .none
    
    private(set) unowned(unsafe) var document: Document
    
    internal init(vertex: Triangle.Vertex,
                  document: Document) {
     
        self.document = document
        
        guard let intermediate = document.region(intermediate: vertex) else {
            
            updateDefaultSelection()
             
            return
        }
        
        selection = .region(vertex: intermediate.vertex)
    }
}

extension WorldViewModel {
    
    internal func location(_ point: CGPoint) -> CGPoint {
        
        editorView.convert(point,
                           from: nil)
    }
    
    internal func hit(_ point: CGPoint) -> Triangle.HitTest? {
        
        guard let pointInWorld = editorView.hit(point) else { return nil }
        
        return .init(pointInWorld,
                     .region)
    }
}

extension WorldViewModel {
    
    internal func load() {
        
        //TODO: Tidy up editor view loading
        editorView.load(regions: Array(document.regionIntermediates.keys))
    }
    
    internal func reload() {
        
        let regions = OutlineViewNode(displayName: "Regions",
                                      image: NSImage(icon: .hexagon),
                                      children: Array(document.regionIntermediates.values))
        
        let zones = OutlineViewNode(displayName: "Zones",
                                    image: NSImage(icon: .rhombus),
                                    children: Array(document.zoneIntermediates.values))
        
        contents = [OutlineViewNode(displayName: "World",
                                    children: [regions,
                                               zones],
                                    isGroup: true)]
    }
}

extension WorldViewModel {
    
    // MARK: Selection
    
    internal func update(selection value: Document.Selection) { selection = value }
    
    internal func updateDefaultSelection() {
        
        guard let region = document.regionIntermediates.values.first else {
        
            selection = .none
            
            return
        }
        
        selection = .region(vertex: region.vertex)
    }
    
    // MARK: Camera
    
    internal func camera(focus value: CGPoint) {
        
        editorView.camera(focus: value)
    }
    
    internal func camera(translate value: CGPoint) {
        
        editorView.camera(translate: value.normalized())
    }
    
    internal func camera(zoom value: Double) {
        
        editorView.camera(zoom: value)
    }
    
    // MARK: Cursor
    
    internal func cursor(focus value: Triangle.HitTest) {
        
        editorView.cursor(focus: value)
    }
    
    // MARK: Region Intermediate
    
    public func region(intermediate vertex: Triangle.Vertex) -> RegionIntermediate? {
        
        document.region(intermediate: vertex)
    }
    
    // MARK: Zone Intermediate
    
    public func zone(intermediate vertex: Triangle.Vertex) -> ZoneIntermediate? {
        
        document.zone(intermediate: vertex)
    }
    
    // MARK: Regions
    
    internal func delete(region vertex: Triangle.Vertex) throws {
        
        try document.delete(region: vertex)
    }
    
    // MARK: Zones
    
    internal func delete(zone vertex: Triangle.Vertex) throws {
        
        try document.delete(zone: vertex)
    }
}
