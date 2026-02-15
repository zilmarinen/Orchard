//
//  NSImage.swift
//
//  Created by Zack Brown on 23/07/2025.
//

import AppKit

extension NSImage {
    
    public enum Icon: String {
        
        case bridge = "distribute.horizontal"
        case building
        case chevronBackward = "chevron.backward"
        case circle
        case circlebadge
        case hammer
        case hexagon
        case footprint = "grid"
        case mountain = "mountain.2"
        case path = "point.topleft.down.to.point.bottomright.curvepath"
        case pin = "mappin.and.ellipse"
        case share = "square.and.arrow.up"
        case slider = "slider.horizontal.3"
        case square
        case stairs
        case rhombus
        case tree
        case triangle
        case waves = "water.waves"
    }
    
    public convenience init?(icon: Icon) {
        
        self.init(systemSymbolName: icon.rawValue,
                  accessibilityDescription: icon.rawValue)
    }
}
