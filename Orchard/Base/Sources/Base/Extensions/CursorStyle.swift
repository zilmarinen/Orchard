//
//  CursorStyle.swift
//
//  Created by Zack Brown on 28/10/2025.
//

import AppKit
import Harvest

extension CursorStyle {
    
    public var image: NSImage? {
        
        switch self {
            
        case .footprint: .init(image: .footprint)
        case .hexagonal: .init(image: .hexagon)
        case .triangle: .init(image: .triangle)
        case .vertex: .init(image: .circlebadge)
        }
    }
}
