//
//  NSToolbarItem.swift
//  Base
//
//  Created by Zack Brown on 11/07/2025.
//

import AppKit

extension NSToolbarItem {
    
    public convenience init(identifier: ItemIdentifier) {
        
        self.init(itemIdentifier: identifier.identifier)
        
        label = identifier.id
        title = identifier.id
        toolTip = identifier.id
        paletteLabel = identifier.id
        image = identifier.image
        isBordered = false
    }
    
    public enum ItemIdentifier: String,
                                Identifiable {
        
        case debug = "Debug"
        
        public var id: String { rawValue }
        
        public var identifier: NSToolbarItem.Identifier { .init(rawValue) }
        
        public var image: NSImage? { NSImage(systemSymbolName: symbolName,
                                              accessibilityDescription: id) }
        
        private var symbolName: String {
            
            switch self {
                
            case .debug: "ladybug"
            }
        }
    }
}
