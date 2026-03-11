//
//  WorldViewModel.swift
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit
import Base
import Deltille
import Harvest
import Silhouette

@MainActor
internal class WorldViewModel {
    
    private(set) var contents: [any TreeNode] = []
    
    private(set) var selection: Document.Selection = .none
    
    private(set) unowned(unsafe) var document: Document
    
    internal init(vertex: Triangle.Vertex,
                  document: Document) {
     
        self.document = document
        
        guard let region = document.region(for: vertex) else {
            
            updateDefaultSelection()
             
            return
        }
        
        selection = .region(vertex: region.origin)
    }
}

extension WorldViewModel {
    
    internal func reload() {
        
        let regions = OutlineViewNode(displayName: "Regions",
                                      image: NSImage(icon: .hexagon),
                                      children: document.regionIntermediates)
        
        let zones = OutlineViewNode(displayName: "Zones",
                                    image: NSImage(icon: .rhombus),
                                    children: document.zoneIntermediates)
        
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
        
        guard let region = document.regionIntermediates.first else {
        
            selection = .none
            
            return
        }
        
        selection = .region(vertex: region.origin)
    }
    
    // MARK: Regions
    
    internal var regions: [Region] {
        
        document.regionIntermediates
    }
    
    internal func region(for vertex: Triangle.Vertex) -> Region? {
        
        document.region(for: vertex)
    }
    
    internal func create(region vertex: Triangle.Vertex) -> Region {
        
        document.create(region: vertex)
    }
    
    internal func delete(region vertex: Triangle.Vertex) {
        
        document.delete(region: vertex)
    }
    
    // MARK: Zones
    
    internal func zone(for vertex: Triangle.Vertex) -> ZoneIntermediate? {
        
        document.zone(for: vertex)
    }
    
    internal func create(zone vertex: Triangle.Vertex) -> ZoneIntermediate {
        
        document.create(zone: vertex)
    }
    
    internal func delete(zone vertex: Triangle.Vertex) {
        
        document.delete(zone: vertex)
    }
}
