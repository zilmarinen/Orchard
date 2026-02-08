//
//  CursorStyle.swift
//  Base
//
//  Created by Zack Brown on 08/02/2026.
//

import AppKit
import Harvest

extension CursorStyle: HasIcon {
    
    public var icon: NSImage.Icon {
        
        switch self {
            
        case .footprint: .footprint
        case .hexagonal: .hexagon
        case .triangle: .triangle
        case .vertex: .circle
        }
    }
}
