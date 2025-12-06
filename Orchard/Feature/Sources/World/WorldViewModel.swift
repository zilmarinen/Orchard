//
//  WorldViewModel.swift
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit
import Base
import Deltille
import Harvest
import OutlineView

@MainActor
internal class WorldViewModel {
    
    private(set) var contents: [any TreeNode] = []
    
    private(set) var selection: Document.Selection = .none
    
    private(set) unowned(unsafe) var document: Document
    
    internal init(triangle: Triangle,
                  document: Document) {
     
        self.document = document
        
        guard let region = document.region(for: triangle) else {
            
            updateDefaultSelection()
             
            return
        }
        
        selection = .region(triangle: region.triangle)
    }
}

extension WorldViewModel {
    
    internal func reload() {
        
        let regions = OutlineViewNode(displayName: "Regions",
                                      image: NSImage(image: .hexagon),
                                      children: document.regionIntermediates)
        
        let zones = OutlineViewNode(displayName: "Zones",
                                    image: NSImage(image: .rhombus),
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
        
        selection = .region(triangle: region.triangle)
    }
    
    // MARK: Regions
    
    internal var regions: [Region] {
        
        document.regionIntermediates
    }
    
    internal func region(for triangle: Triangle) -> Region? {
        
        document.region(for: triangle)
    }
    
    internal func create(region triangle: Triangle) -> Region {
        
        document.create(region: triangle)
    }
    
    internal func delete(region triangle: Triangle) {
        
        document.delete(region: triangle)
    }
    
    // MARK: Zones
    
    internal func zone(for triangle: Triangle) -> ZoneIntermediate? {
        
        document.zone(for: triangle)
    }
    
    internal func create(zone triangle: Triangle) -> ZoneIntermediate {
        
        document.create(zone: triangle)
    }
    
    internal func delete(zone triangle: Triangle) {
        
        document.delete(zone: triangle)
    }
}
