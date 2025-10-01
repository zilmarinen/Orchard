//
//  WorldViewModel.swift
//  Feature
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
    
    internal init(coordinate: Coordinate,
                  document: Document) {
     
        self.document = document
        
        guard let region = document.region(for: coordinate) else {
            
            updateDefaultSelection()
            
            return
        }
        
        selection = .region(coordinate: region.coordinate)
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
        
        selection = .region(coordinate: region.coordinate)
    }
    
    // MARK: Regions
    
    internal var regions: [Region] {
        
        document.regionIntermediates
    }
    
    internal func region(for coordinate: Coordinate) -> Region? {
        
        document.region(for: coordinate)
    }
    
    internal func create(region coordinate: Coordinate) -> Region {
        
        document.create(region: coordinate)
    }
    
    internal func delete(region coordinate: Coordinate) {
        
        document.delete(region: coordinate)
    }
    
    // MARK: Zones
    
    internal func zone(for coordinate: Coordinate) -> ZoneIntermediate? {
        
        document.zone(for: coordinate)
    }
    
    internal func create(zone coordinate: Coordinate) -> ZoneIntermediate {
        
        document.create(zone: coordinate)
    }
    
    internal func delete(zone coordinate: Coordinate) {
        
        document.delete(zone: coordinate)
    }
}
