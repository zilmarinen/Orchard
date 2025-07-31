//
//  NSToolbarItem.swift
//  Base
//
//  Created by Zack Brown on 11/07/2025.
//

import AppKit

extension NSToolbarItem {
    
    public convenience init(item: Item) {
        
        self.init(itemIdentifier: item.identifier)
        
        label = item.id
        title = item.id
        toolTip = item.id
        paletteLabel = item.id
        image = item.image
        isNavigational = item.isNavigational
        isBordered = false
    }
    
    public enum Item: String,
                      Identifiable {
        
        case chevronBackward = "Back"
        
        public var id: String { rawValue }
        
        public var isNavigational: Bool { self == .chevronBackward }
        
        public var identifier: NSToolbarItem.Identifier {
            
            switch self {
                
            case .chevronBackward: .chevronBackward
            }
        }
        
        internal var image: NSImage? {
            
            switch self {
                
            case .chevronBackward: .init(image: .chevronBackward)
            }
        }
    }
}

extension NSToolbarItem.Identifier {
    
    public static let chevronBackward = NSToolbarItem.Identifier("chevronBackward")
}
