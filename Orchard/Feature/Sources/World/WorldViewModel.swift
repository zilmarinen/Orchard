//
//  WorldViewModel.swift
//  Feature
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit
import Base
import Deltille
import OutlineView

@MainActor
internal class WorldViewModel {
    
    internal enum Selection {
        
        case none
        case region(coordinate: Coordinate)
    }
    
    private(set) var selection: Selection = .none
    
    private(set) unowned(unsafe) var document: Document
    
    init(document: Document) {
     
        self.document = document
    }
}

extension WorldViewModel {
    
    public var contents: [any TreeNode] {
        
        let regions = OutlineViewNode(name: "Regions",
                                      image: NSImage(image: .hexagon),
                                      children: document.regionIntermediates)
        
        let zones = OutlineViewNode(name: "Zones",
                                    image: NSImage(image: .rhombus),
                                    children: document.zoneIntermediates)
        
        return [OutlineViewNode(name: "World",
                                children: [regions,
                                           zones],
                                isGroup: true),
                OutlineViewNode(name: "Other",
                                children: [],
                                isGroup: true)]
    }
}

extension WorldViewModel {
    
    internal func update(selection value: Selection) { selection = value }
}
