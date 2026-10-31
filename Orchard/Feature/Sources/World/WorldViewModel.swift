//
//  WorldViewModel.swift
//
//  Created by Zack Brown on 24/07/2025.
//

import Alluvium
import AppKit
import Base
import Deltille
import Harvest
import SpriteKit
import Silhouette

@MainActor
internal class WorldViewModel {

    private(set) var contents: [any TreeNode] = []
    
    private(set) var selection: Document.Selection = .none
    
    private(set) unowned(unsafe) var document: Document
    
    internal init(triangle: Triangle,
                  document: Document) {
     
        self.document = document
        
        guard let intermediate = document.region(intermediate: triangle) else {
            
            updateDefaultSelection()
             
            return
        }
        
        selection = .region(triangle: intermediate.triangle)
    }
}

extension WorldViewModel {
    
    internal func load() {
        
        //TODO:
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
        
        selection = .region(triangle: region.triangle)
    }
    
    // MARK: Region Intermediate
    
    public func region(intermediate triangle: Triangle) -> RegionIntermediate? {
        
        document.region(intermediate: triangle)
    }
    
    // MARK: Zone Intermediate
    
    public func zone(intermediate triangle: Triangle) -> ZoneIntermediate? {
        
        document.zone(intermediate: triangle)
    }
    
    // MARK: Regions
    
    internal func delete(region triangle: Triangle) throws {
        
        //try document.delete(region: triangle)
    }
    
    // MARK: Zones
    
    internal func delete(zone triangle: Triangle) throws {
        
        //try document.delete(zone: triangle)
    }
}
