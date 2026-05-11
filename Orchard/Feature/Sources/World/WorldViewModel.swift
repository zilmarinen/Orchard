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
        
        selection = .region(vertex: region.vertex)
    }
}

extension WorldViewModel {
    
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
    
    // MARK: Region Intermediate
    
    public func region(intermediate vertex: Triangle.Vertex) -> RegionIntermediate? {
        
        document.region(intermediate: vertex)
    }
    
    // MARK: Zone Intermediate
    
    public func zone(intermediate vertex: Triangle.Vertex) -> ZoneIntermediate? {
        
        document.zone(intermediate: vertex)
    }
    
    // MARK: Regions
    
    internal func delete(region vertex: Triangle.Vertex) {
        
        document.delete(region: vertex)
    }
    
    // MARK: Zones
    
    internal func delete(zone vertex: Triangle.Vertex) {
        
        document.delete(zone: vertex)
    }
}
