//
//  NSImage.swift
//
//  Created by Zack Brown on 23/07/2025.
//

import AppKit

extension NSImage {
    
    public enum Image: String {
        
        case chevronBackward = "chevron.backward"
        case circle
        case circlebadge
        case hexagon
        case share = "square.and.arrow.up"
        case square
        case rhombus
        case triangle
    }
    
    public convenience init?(image: Image) {
        
        self.init(systemSymbolName: image.rawValue,
                  accessibilityDescription: image.rawValue)
    }
}
